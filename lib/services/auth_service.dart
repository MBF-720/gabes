import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/user_model.dart';

/// Represents the result of a login attempt.
class AuthResult {
  final bool success;
  final String? errorMessage;
  const AuthResult({required this.success, this.errorMessage});
}

/// ─── AuthService ─────────────────────────────────────────────────────────────
/// Central auth state + service. Extends ChangeNotifier so GoRouter and
/// any listening widget can react to auth changes.
class AuthService extends ChangeNotifier {
  UserModel? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;

  /// True after [checkAuth] has completed (even if the user is not logged in).
  bool _initialized = false;

  // ── Getters ──────────────────────────────────────────────────────────────
  UserModel? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _user != null && _accessToken != null;
  bool get isLoading => _isLoading;
  bool get initialized => _initialized;
  String get role => _user?.role ?? '';

  // ── Public API ────────────────────────────────────────────────────────────

  /// Called on app launch to restore an existing session from storage.
  Future<void> checkAuth() async {
    _isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.keyAccessToken);
      _refreshToken = prefs.getString(AppConstants.keyRefreshToken);

      if (token != null) {
        _accessToken = token;
        // Validate token by fetching /auth/me
        final valid = await _fetchMe();
        if (!valid) {
          // Token may be expired — try to refresh
          if (_refreshToken != null) {
            await _doRefresh();
          } else {
            await _clearSession(notify: false);
          }
        }
      }
    } catch (_) {
      await _clearSession(notify: false);
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  /// POST /api/auth/login — authenticates the user and stores tokens.
  Future<AuthResult> login(
      String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': email.trim(), 'password': password, 'role': role}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _accessToken = data['accessToken'] as String;
        _refreshToken = data['refreshToken'] as String?;
        _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

        // Persist tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyAccessToken, _accessToken!);
        if (_refreshToken != null) {
          await prefs.setString(
              AppConstants.keyRefreshToken, _refreshToken!);
        }

        notifyListeners();
        return const AuthResult(success: true);
      } else {
        final msg = data['error'] ?? data['message'] ?? 'Login failed';
        return AuthResult(success: false, errorMessage: msg as String);
      }
    } catch (_) {
      return const AuthResult(
          success: false,
          errorMessage: 'Connection error — is the server running?');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// POST /api/auth/logout — invalidates the refresh token server-side and
  /// clears the local session.
  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode({'refreshToken': _refreshToken}),
      );
    } catch (_) {
      // Swallow network errors — we always clear locally
    }
    await _clearSession(notify: true);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Calls GET /api/auth/me and updates [_user]. Returns whether the call
  /// succeeded (token is valid).
  Future<bool> _fetchMe() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/me'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Calls POST /api/auth/refresh to swap the stored refresh token for a new
  /// access token, then re-fetches the user profile.
  Future<bool> _doRefresh() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': _refreshToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _accessToken = data['accessToken'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyAccessToken, _accessToken!);
        return await _fetchMe();
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _clearSession({required bool notify}) async {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAccessToken);
    await prefs.remove(AppConstants.keyRefreshToken);
    if (notify) notifyListeners();
  }
}

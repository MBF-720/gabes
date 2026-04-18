/// Application-wide constants.
class AppConstants {
  AppConstants._();

  /// Base URL for the backend API.
  static const String apiBaseUrl = 'http://10.0.2.2:3000/api';

  /// SharedPreferences keys for persistent auth tokens.
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
}

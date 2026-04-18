import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Home screen — citizen reporting hub.
/// Matches the home_citizen_reporting UI reference.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Welcome ──
              const SizedBox(height: 8),
              Text(
                'Hello, Ahmed!',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'How can we help protect Gabès today?',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),

              // ── Report an Issue Card ──
              _ReportIssueCard(),
              const SizedBox(height: 16),

              // ── Your Impact ──
              _ImpactCard(),
              const SizedBox(height: 28),

              // ── Recent Community Actions ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Community Actions',
                      style: AppTextStyles.titleLarge),
                  Text('View All',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      )),
                ],
              ),
              const SizedBox(height: 16),

              _CommunityActionCard(
                icon: Icons.water_drop_outlined,
                title: 'Water Leak',
                time: '2 hours ago • Industrial Zone',
                status: 'Verified',
                statusColor: AppColors.tertiaryFixed,
                statusTextColor: AppColors.tertiaryContainer,
                description:
                    'Reported large puddle forming near the main junction, suspected pipe burst.',
              ),
              const SizedBox(height: 12),
              _CommunityActionCard(
                icon: Icons.delete_outline,
                title: 'Illegal Dumping',
                time: '5 hours ago • Coastal Road',
                status: 'In Progress',
                statusColor: AppColors.secondaryContainer,
                statusTextColor: AppColors.onSecondaryContainer,
                description:
                    'Construction debris dumped along the coastal path overnight.',
              ),
              const SizedBox(height: 12),
              _CommunityActionCard(
                icon: Icons.air,
                title: 'Air Quality Drop',
                time: 'Yesterday • City Center',
                status: 'Verified',
                statusColor: AppColors.tertiaryFixed,
                statusTextColor: AppColors.tertiaryContainer,
                description:
                    'Strong chemical odor detected in the downtown area, sensors confirm spike in VOCs.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Report an Issue Card ───────────────────────────────────────────────────
class _ReportIssueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 60,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative blob ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withOpacity(0.12),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.add_circle,
                  color: AppColors.primary, size: 48),
              const SizedBox(height: 20),
              Text('Report an Issue',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 8),
              Text(
                'Quickly log environmental concerns. Your reports go directly to local authorities.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Quick chips ──
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ActionChip(icon: Icons.air, label: 'Pollution'),
                  _ActionChip(icon: Icons.water_drop, label: 'Water'),
                  _ActionChip(icon: Icons.delete, label: 'Waste'),
                ],
              ),
            ],
          ),

          // ── Arrow button ──
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.30),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Chip ────────────────────────────────────────────────────────────
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Impact Card ────────────────────────────────────────────────────────────
class _ImpactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.show_chart,
              color: AppColors.tertiary, size: 36),
          const SizedBox(height: 12),
          Text('Your Impact',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 8),
          Text('12',
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 4),
          Text('Reports resolved this month',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

// ─── Community Action Card ──────────────────────────────────────────────────
class _CommunityActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String description;

  const _CommunityActionCard({
    required this.icon,
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.03),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                    Text(time,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.outline,
                          fontSize: 11,
                        )),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusTextColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
                height: 1.4,
              )),
        ],
      ),
    );
  }
}

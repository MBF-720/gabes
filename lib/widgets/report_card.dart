import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Report log card for the Citizen Home screen.
/// Displays a thumbnail, title, description, status badge, location, and time.
class ReportCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReportCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isError = data['statusColor'] == 'error';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.outlineVariant.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              data['imageUrl'] as String,
              width: 90,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 72,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.outline),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data['title'] as String,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isError
                            ? AppColors.errorContainer
                            : AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        data['status'] as String,
                        style: TextStyle(
                          color: isError
                              ? AppColors.onErrorContainer
                              : AppColors.onSecondaryContainer,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  data['description'] as String,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Meta: time + location
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        color: AppColors.outline, size: 13),
                    const SizedBox(width: 4),
                    Text(data['time'] as String,
                        style: const TextStyle(
                            color: AppColors.outline, fontSize: 11)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on,
                        color: AppColors.outline, size: 13),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data['location'] as String,
                        style: const TextStyle(
                            color: AppColors.outline, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

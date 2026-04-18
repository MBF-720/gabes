import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Dashboard screen — Environmental Insights with KPIs, charts, and metrics.
/// Combines dashboard_insights + dashboard_detailed_metrics UI references.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              // ── Header ──
              const SizedBox(height: 8),
              Text('Environmental Insights',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 4),
              Text('Real-time data overview for Gabès region.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary,
                  )),
              const SizedBox(height: 16),

              // ── Export Button ──
              _GradientButton(
                label: 'Export Report',
                icon: Icons.download,
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // ── Alert Card ──
              _AlertCard(),
              const SizedBox(height: 20),

              // ── AQI Chart ──
              _AqiChartCard(),
              const SizedBox(height: 16),

              // ── Community Impact ──
              _CommunityImpactCard(),
              const SizedBox(height: 16),

              // ── KPI Row: Best Time + Peak Level ──
              Row(
                children: [
                  Expanded(child: _KpiMetricCard(
                    label: 'BEST TIME',
                    value: '42',
                    badge: 'Good',
                    badgeColor: AppColors.tertiaryFixed,
                    badgeTextColor: AppColors.tertiary,
                    timeRange: '08:00 - 11:00',
                    icon: Icons.wb_sunny_outlined,
                    iconColor: AppColors.tertiary,
                    decorColor: AppColors.tertiaryFixed,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _KpiMetricCard(
                    label: 'PEAK LEVEL',
                    value: '85',
                    badge: 'Moderate',
                    badgeColor: AppColors.secondaryFixed,
                    badgeTextColor: AppColors.onSecondaryFixed,
                    timeRange: '14:00 - 17:00',
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.secondary,
                    decorColor: AppColors.secondaryFixed,
                  )),
                ],
              ),
              const SizedBox(height: 16),

              // ── Hourly Forecast ──
              _HourlyForecastCard(),
              const SizedBox(height: 16),

              // ── Pollutant Breakdown ──
              _PollutantBreakdownCard(),
              const SizedBox(height: 16),

              // ── Water Quality ──
              _WaterQualityCard(),
              const SizedBox(height: 16),

              // ── Resolved Issues ──
              _ResolvedIssuesCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Gradient Button ────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.30),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Alert Card ─────────────────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.10),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning, color: AppColors.error, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('High PM2.5 detected in Industrial Zone',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.onErrorContainer,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 4),
                Text(
                  'Levels exceeded safe limits by 45% in the last 2 hours. Advisory sent to local residents.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onErrorContainer.withOpacity(0.80),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.close,
              color: AppColors.onErrorContainer.withOpacity(0.50), size: 20),
        ],
      ),
    );
  }
}

// ─── AQI Chart Card ─────────────────────────────────────────────────────────
class _AqiChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.03),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Air Quality Index',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                      )),
                  Text('7-Day Trend',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                      )),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.tertiary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Good',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _AqiChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AqiChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Data points (normalized 0–1)
    final points = [0.40, 0.35, 0.45, 0.30, 0.15, 0.25, 0.20, 0.15, 0.30, 0.10, 0.15];

    final path = Path();
    final fillPath = Path();
    final segW = w / (points.length - 1);

    // Build curve
    for (var i = 0; i < points.length; i++) {
      final x = segW * i;
      final y = h * points[i];
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        final px = segW * (i - 1);
        final py = h * points[i - 1];
        final cx1 = px + segW * 0.5;
        final cx2 = x - segW * 0.5;
        path.cubicTo(cx1, py, cx2, y, x, y);
        fillPath.cubicTo(cx1, py, cx2, y, x, y);
      }
    }

    // Fill gradient
    fillPath.lineTo(w, h);
    fillPath.lineTo(0, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x330058BD), Color(0x000058BD)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Data dots
    final dotBg = Paint()..color = Colors.white;
    final dotBorder = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final idx in [3, 7, 9]) {
      final x = segW * idx;
      final y = h * points[idx];
      canvas.drawCircle(Offset(x, y), 5, dotBg);
      canvas.drawCircle(Offset(x, y), 5, dotBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Community Impact Card ──────────────────────────────────────────────────
class _CommunityImpactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Impact',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 4),
          Text('Score based on active participation',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
              )),
          const SizedBox(height: 24),
          Text('84',
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.primary,
                fontSize: 64,
              )),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.84,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Top 15% region',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

// ─── KPI Metric Card ────────────────────────────────────────────────────────
class _KpiMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String timeRange;
  final IconData icon;
  final Color iconColor;
  final Color decorColor;

  const _KpiMetricCard({
    required this.label,
    required this.value,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.timeRange,
    required this.icon,
    required this.iconColor,
    required this.decorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.ambientShadow,
      ),
      child: Stack(
        children: [
          // Decorative corner
          Positioned(
            top: -32,
            right: -32,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: decorColor.withOpacity(0.30),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.onSurfaceVariant,
                      )),
                  Icon(icon, color: iconColor, size: 28),
                ],
              ),
              const SizedBox(height: 12),
              Text(value,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: badgeTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(badge,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: badgeTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(timeRange,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Hourly Forecast Card ───────────────────────────────────────────────────
class _HourlyForecastCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bars = [
      _BarData('8am', 0.40, AppColors.tertiaryFixed, '42'),
      _BarData('10am', 0.45, AppColors.tertiaryFixed, '48'),
      _BarData('12pm', 0.60, AppColors.secondaryFixed, '65'),
      _BarData('2pm', 0.85, AppColors.primary.withOpacity(0.80), '85'),
      _BarData('4pm', 0.70, AppColors.secondaryFixed, '72'),
      _BarData('6pm', 0.50, AppColors.tertiaryFixed, '52'),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.ambientShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hourly Forecast',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('AQI LEVEL',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars.map((bar) {
                final isPeak = bar.label == '2pm';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(bar.aqi,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              color: isPeak
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 4),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: bar.height,
                            child: Container(
                              decoration: BoxDecoration(
                                color: bar.color,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(bar.label,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              color: isPeak
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              fontWeight:
                                  isPeak ? FontWeight.w800 : FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double height;
  final Color color;
  final String aqi;
  const _BarData(this.label, this.height, this.color, this.aqi);
}

// ─── Pollutant Breakdown Card ───────────────────────────────────────────────
class _PollutantBreakdownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.ambientShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science_outlined,
                  color: AppColors.secondary, size: 22),
              const SizedBox(width: 8),
              Text('Pollutant Breakdown',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
          const SizedBox(height: 24),
          _PollutantRow(
              name: 'PM2.5',
              sub: 'Fine Particulate Matter',
              value: '28 µg/m³',
              progress: 0.60,
              color: AppColors.secondary),
          const SizedBox(height: 20),
          _PollutantRow(
              name: 'NO2',
              sub: 'Nitrogen Dioxide',
              value: '15 µg/m³',
              progress: 0.30,
              color: AppColors.tertiary),
          const SizedBox(height: 20),
          _PollutantRow(
              name: 'SO2',
              sub: 'Sulfur Dioxide',
              value: '8 µg/m³',
              progress: 0.15,
              color: AppColors.tertiary),
        ],
      ),
    );
  }
}

class _PollutantRow extends StatelessWidget {
  final String name, sub, value;
  final double progress;
  final Color color;
  const _PollutantRow({
    required this.name,
    required this.sub,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
                Text(sub,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    )),
              ],
            ),
            Text(value,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                )),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

// ─── Water Quality Card ─────────────────────────────────────────────────────
class _WaterQualityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bars = [0.40, 0.60, 0.30, 0.80, 0.50];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.03),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Water Quality',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 2),
              Text('Coastline Avg',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontSize: 11,
                  )),
              const SizedBox(height: 16),
              SizedBox(
                height: 90,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(bars.length, (i) {
                    final isHighlight = i == 3;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FractionallySizedBox(
                          heightFactor: bars[i],
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHighlight
                                  ? AppColors.primary.withOpacity(0.60)
                                  : AppColors.surfaceContainerHighest,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Resolved Issues Card ───────────────────────────────────────────────────
class _ResolvedIssuesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerLowest,
            AppColors.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.03),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Resolved Issues',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
                const SizedBox(height: 4),
                Text('Community reported and verified fixed.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondary,
                    )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.trending_up,
                        color: AppColors.tertiary, size: 16),
                    const SizedBox(width: 4),
                    Text('+12% this month',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _DonutPainter(),
              child: Center(
                child: Text('342',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * 0.75,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

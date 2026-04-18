import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Environmental map screen — full-screen Gabès map with pollution heatmap,
/// wind direction, critical zones, glassmorphism search, and floating info card.
/// Matches the environmental_map_gab_s UI reference.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Simulated satellite map background ──
          _MapBackground(),

          // ── Heatmap overlay ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.error.withOpacity(0.15),
                  Colors.transparent,
                  AppColors.tertiary.withOpacity(0.08),
                ],
              ),
            ),
          ),

          // ── Map pins: Critical zone ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: MediaQuery.of(context).size.width * 0.35,
            child: _CriticalPin(pulseAnim: _pulseAnim),
          ),

          // ── Map pin: Green zone ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.48,
            left: MediaQuery.of(context).size.width * 0.65,
            child: _GreenPin(),
          ),

          // ── Wind direction arrows ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: MediaQuery.of(context).size.width * 0.55,
            child: Transform.rotate(
              angle: 0.785, // NE direction
              child: Icon(Icons.air,
                  color: AppColors.onSurfaceVariant.withOpacity(0.60),
                  size: 36),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.22,
            left: MediaQuery.of(context).size.width * 0.72,
            child: Transform.rotate(
              angle: 0.785,
              child: Icon(Icons.air,
                  color: AppColors.onSurfaceVariant.withOpacity(0.40),
                  size: 28),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Transform.rotate(
              angle: 0.4,
              child: Icon(Icons.air,
                  color: AppColors.onSurfaceVariant.withOpacity(0.35),
                  size: 32),
            ),
          ),

          // ── Search bar + filters ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  _SearchBar(),
                  const SizedBox(height: 12),
                  _FilterChips(
                    selectedIndex: _selectedFilter,
                    onSelect: (i) => setState(() => _selectedFilter = i),
                  ),
                ],
              ),
            ),
          ),

          // ── Floating info card ──
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: _InfoCard(),
          ),
        ],
      ),
    );
  }
}

// ─── Simulated Map Background ───────────────────────────────────────────────
class _MapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4A76A), // Sandy desert tone
            Color(0xFFC4A862),
            Color(0xFF8CAF7A), // Oasis green
            Color(0xFF7AB5A0), // Coastal teal
            Color(0xFF6BA8B2),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _MapDetailsPainter(),
      ),
    );
  }
}

class _MapDetailsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Simulate coast line
    final coastPath = Path()
      ..moveTo(w * 0.6, 0)
      ..quadraticBezierTo(w * 0.55, h * 0.3, w * 0.7, h * 0.5)
      ..quadraticBezierTo(w * 0.85, h * 0.7, w * 0.75, h)
      ..lineTo(w, h)
      ..lineTo(w, 0)
      ..close();

    final seaPaint = Paint()
      ..color = const Color(0xFF6BA8B2).withOpacity(0.40);
    canvas.drawPath(coastPath, seaPaint);

    // Grid lines simulating map grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 0.5;

    for (var x = 0.0; x < w; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (var y = 0.0; y < h; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Road-like lines
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * 0.1, h * 0.4), Offset(w * 0.5, h * 0.35), roadPaint);
    canvas.drawLine(Offset(w * 0.5, h * 0.35), Offset(w * 0.6, h * 0.5), roadPaint);
    canvas.drawLine(Offset(w * 0.2, h * 0.6), Offset(w * 0.5, h * 0.55), roadPaint);
    canvas.drawLine(Offset(w * 0.3, h * 0.2), Offset(w * 0.35, h * 0.6), roadPaint);

    // Industrial zone indicator (dotted area)
    final industrialPaint = Paint()
      ..color = AppColors.error.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.40, h * 0.32),
        width: w * 0.25,
        height: h * 0.12,
      ),
      industrialPaint,
    );

    // Oasis zone indicator
    final oasisPaint = Paint()
      ..color = AppColors.tertiary.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.65, h * 0.50),
        width: w * 0.15,
        height: h * 0.10,
      ),
      oasisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Critical Zone Pin ──────────────────────────────────────────────────────
class _CriticalPin extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _CriticalPin({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: pulseAnim,
          builder: (_, child) => Transform.scale(
            scale: pulseAnim.value,
            child: child,
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.90),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.30),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.warning_rounded,
                color: Colors.white, size: 22),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

// ─── Green Zone Pin ─────────────────────────────────────────────────────────
class _GreenPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withOpacity(0.90),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiary.withOpacity(0.30),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.eco, color: Colors.white, size: 18),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

// ─── Search Bar ─────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withOpacity(0.80),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 50,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.secondary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Search Gabès locations...',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tune,
                    color: AppColors.onSurfaceVariant, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Filter Chips ───────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const _FilterChips({required this.selectedIndex, required this.onSelect});

  static const _filters = [
    _FilterDef(Icons.air, 'Air Quality', AppColors.primary),
    _FilterDef(Icons.factory_outlined, 'Industrial', AppColors.error),
    _FilterDef(Icons.park_outlined, 'Green Zones', AppColors.tertiary),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final isActive = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.surfaceContainerLowest.withOpacity(0.95)
                        : AppColors.surfaceContainerLowest.withOpacity(0.80),
                    borderRadius: BorderRadius.circular(999),
                    border: isActive
                        ? Border.all(
                            color: f.color.withOpacity(0.40), width: 1.5)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(f.icon, color: f.color, size: 16),
                      const SizedBox(width: 6),
                      Text(f.label,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterDef {
  final IconData icon;
  final String label;
  final Color color;
  const _FilterDef(this.icon, this.label, this.color);
}

// ─── Floating Info Card ─────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withOpacity(0.80),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 60,
                offset: const Offset(0, 25),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gabès Center',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                          )),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: AppColors.onSurfaceVariant, size: 14),
                          const SizedBox(width: 4),
                          Text('Live Monitoring',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.tertiaryContainer, size: 14),
                        const SizedBox(width: 4),
                        Text('GOOD',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.tertiaryContainer,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── AQI ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('45',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('AQI',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Wind + PM2.5 ──
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WIND',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 10,
                              )),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.north_east,
                                  color: AppColors.secondary, size: 18),
                              const SizedBox(width: 6),
                              Text('12 km/h NE',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PM2.5',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 10,
                              )),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.blur_on,
                                  color: AppColors.secondary, size: 18),
                              const SizedBox(width: 6),
                              Text('10 µg/m³',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── CTA ──
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.20),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text('View Full Report',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

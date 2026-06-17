import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated radar-pulse indicator shown while scanning for devices.
class ScanningIndicator extends StatefulWidget {
  const ScanningIndicator({super.key, this.size = 120});

  final double size;

  @override
  State<ScanningIndicator> createState() => _ScanningIndicatorState();
}

class _ScanningIndicatorState extends State<ScanningIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _rotateController]),
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(
              pulseProgress: _pulseController.value,
              sweepAngle: _rotateController.value * 2 * 3.14159,
            ),
            child: Center(
              child: Icon(
                Icons.wifi_tethering,
                size: widget.size * 0.3,
                color: AppColors.primaryLight,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.pulseProgress,
    required this.sweepAngle,
  });

  final double pulseProgress;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw concentric expanding rings.
    for (var i = 0; i < 3; i++) {
      final offset = (pulseProgress + i / 3) % 1.0;
      final radius = maxRadius * offset;
      final opacity = (1.0 - offset).clamp(0.0, 0.4);

      final paint = Paint()
        ..color = AppColors.primaryLight.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }

    // Draw sweep arc.
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: sweepAngle,
        endAngle: sweepAngle + 1.0,
        colors: [
          AppColors.primaryLight.withValues(alpha: 0.0),
          AppColors.primaryLight.withValues(alpha: 0.15),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius * 0.85, sweepPaint);

    // Static outer ring.
    final ringPaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, maxRadius * 0.85, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.55, ringPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter old) => true;
}

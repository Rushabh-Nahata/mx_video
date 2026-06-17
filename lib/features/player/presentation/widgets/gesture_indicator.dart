import 'package:flutter/material.dart';

/// Semi-transparent icon + bar indicator shown during brightness/volume gestures.
class GestureIndicator extends StatelessWidget {
  const GestureIndicator({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;

  /// 0.0 – 1.0
  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            width: 4,
            child: RotatedBox(
              quarterTurns: -1,
              child: LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

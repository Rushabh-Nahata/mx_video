import 'package:flutter/material.dart';

/// Bottom sheet for selecting playback speed.
class SpeedSheet extends StatelessWidget {
  const SpeedSheet({
    super.key,
    required this.currentSpeed,
    required this.onSelect,
  });

  final double currentSpeed;
  final void Function(double speed) onSelect;

  static const _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  static Future<void> show({
    required BuildContext context,
    required double currentSpeed,
    required void Function(double) onSelect,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SpeedSheet(
        currentSpeed: currentSpeed,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Playback Speed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final speed in _speeds)
                  ListTile(
                    title: Text(
                      speed == 1.0 ? 'Normal (1×)' : '$speed×',
                      style: TextStyle(
                        color: speed == currentSpeed
                            ? Colors.orangeAccent
                            : Colors.white,
                        fontWeight: speed == currentSpeed
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: speed == currentSpeed
                        ? const Icon(Icons.check, color: Colors.orangeAccent)
                        : null,
                    onTap: () {
                      onSelect(speed);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

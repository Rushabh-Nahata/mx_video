import 'package:flutter/material.dart';

/// Chevron + label shown briefly when the user double-taps to seek.
class DoubleTapSeekIndicator extends StatelessWidget {
  const DoubleTapSeekIndicator({
    super.key,
    required this.isForward,
    this.seconds = 10,
  });

  final bool isForward;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final icons = isForward
        ? [Icons.chevron_right, Icons.chevron_right, Icons.chevron_right]
        : [Icons.chevron_left, Icons.chevron_left, Icons.chevron_left];

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons
                .asMap()
                .entries
                .map(
                  (e) => AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 100 + e.key * 80),
                    child: Icon(e.value, color: Colors.white, size: 20),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          Text(
            '$seconds s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

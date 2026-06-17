import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';

/// Horizontal row of speed buttons displayed in the player's speed menu.
class SpeedSelector extends StatelessWidget {
  const SpeedSelector({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  final double currentSpeed;
  final void Function(double speed) onSpeedSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.playbackSpeeds.map((speed) {
        final isSelected = speed == currentSpeed;
        return ChoiceChip(
          label: Text('${speed}x'),
          selected: isSelected,
          selectedColor: AppColors.primary,
          onSelected: (_) => onSpeedSelected(speed),
        );
      }).toList(),
    );
  }
}

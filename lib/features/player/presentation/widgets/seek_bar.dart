import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Seek bar with drag support. Reports the new position via [onSeek].
class SeekBar extends StatefulWidget {
  const SeekBar({
    super.key,
    required this.positionMs,
    required this.durationMs,
    required this.onSeek,
  });

  final int positionMs;
  final int durationMs;
  final void Function(int positionMs) onSeek;

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  double get _value {
    if (widget.durationMs == 0) return 0;
    return (_dragValue ?? widget.positionMs) / widget.durationMs;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        activeTrackColor: AppColors.seekBarActive,
        inactiveTrackColor: AppColors.seekBarTrack,
        thumbColor: AppColors.seekBarActive,
      ),
      child: Slider(
        value: _value.clamp(0.0, 1.0),
        onChangeStart: (v) => setState(() => _dragValue = v * widget.durationMs),
        onChanged: (v) => setState(() => _dragValue = v * widget.durationMs),
        onChangeEnd: (v) {
          widget.onSeek((v * widget.durationMs).toInt());
          setState(() => _dragValue = null);
        },
      ),
    );
  }
}

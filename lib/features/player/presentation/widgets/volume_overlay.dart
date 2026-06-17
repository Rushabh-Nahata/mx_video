import 'package:flutter/material.dart';

/// Right-half gesture detector that controls volume via vertical drag.
class VolumeOverlay extends StatelessWidget {
  const VolumeOverlay({super.key, required this.onVerticalDrag});

  final void Function(double delta) onVerticalDrag;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: GestureDetector(
          onVerticalDragUpdate: (d) => onVerticalDrag(d.delta.dy),
          child: const ColoredBox(color: Colors.transparent),
        ),
      ),
    );
  }
}

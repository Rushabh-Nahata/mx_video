import 'package:flutter/material.dart';

/// Left-half gesture detector that controls screen brightness via vertical drag.
class BrightnessOverlay extends StatelessWidget {
  const BrightnessOverlay({super.key, required this.onVerticalDrag});

  final void Function(double delta) onVerticalDrag;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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

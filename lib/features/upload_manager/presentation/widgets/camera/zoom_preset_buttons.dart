import 'package:flutter/material.dart';

class ZoomPresetButtons extends StatelessWidget {
  const ZoomPresetButtons({required this.onSelect, super.key});

  final ValueChanged<double> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [1.0, 2.0, 3.0].map((zoom) {
        return OutlinedButton(
          onPressed: () => onSelect(zoom),
          child: Text('${zoom.toStringAsFixed(0)}x'),
        );
      }).toList(),
    );
  }
}

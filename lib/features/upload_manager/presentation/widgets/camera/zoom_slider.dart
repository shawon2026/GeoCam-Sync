import 'package:flutter/material.dart';

class ZoomSlider extends StatelessWidget {
  const ZoomSlider({required this.value, required this.onChanged, super.key});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(min: 1, max: 5, value: value, onChanged: onChanged);
  }
}

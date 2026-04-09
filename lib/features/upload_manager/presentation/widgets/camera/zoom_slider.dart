import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

class ZoomSlider extends StatelessWidget {
  const ZoomSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 230,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          GlobalText.raw(
            '${value.toStringAsFixed(1)}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.30),
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  min: min,
                  max: max,
                  value: value.clamp(min, max),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          GlobalText.raw(
            '${min.toStringAsFixed(1).replaceAll('.0', '')}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

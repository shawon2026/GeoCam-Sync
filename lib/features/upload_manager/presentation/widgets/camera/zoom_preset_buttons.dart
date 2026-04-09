import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

class ZoomPresetButtons extends StatelessWidget {
  const ZoomPresetButtons({
    required this.selectedZoom,
    required this.onSelect,
    super.key,
  });

  final double selectedZoom;
  final ValueChanged<double> onSelect;

  @override
  Widget build(BuildContext context) {
    final presets = <double>[0.5, 1.0, 2.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: presets.map((zoom) {
        final isActive = (selectedZoom - zoom).abs() < 0.2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () => onSelect(zoom),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFFE5E7EB)
                    : Colors.black.withValues(alpha: 0.34),
              ),
              alignment: Alignment.center,
              child: GlobalText.raw(
                zoom == 1.0
                    ? '1x'
                    : zoom.toStringAsFixed(1).replaceAll('.0', ''),
                style: TextStyle(
                  color: isActive ? const Color(0xFF1F2937) : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

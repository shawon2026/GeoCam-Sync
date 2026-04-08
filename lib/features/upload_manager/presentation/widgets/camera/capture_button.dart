import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class CaptureButton extends StatelessWidget {
  const CaptureButton({
    required this.isCapturing,
    required this.onPressed,
    super.key,
  });

  final bool isCapturing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isCapturing ? null : onPressed,
      child: Text(
        isCapturing ? context.loc.capturingPhoto : context.loc.capturePhoto,
      ),
    );
  }
}

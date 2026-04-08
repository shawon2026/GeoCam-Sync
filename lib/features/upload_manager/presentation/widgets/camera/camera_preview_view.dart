import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class CameraPreviewView extends StatelessWidget {
  const CameraPreviewView({
    required this.cameraLens,
    required this.controller,
    required this.onTapUp,
    super.key,
  });

  final String cameraLens;
  final CameraController? controller;
  final ValueChanged<TapUpDetails> onTapUp;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTapUp: onTapUp,
        child: Container(
          height: 280,
          width: double.infinity,
          color: const Color(0xFF0F172A),
          child: controller != null && controller!.value.isInitialized
              ? CameraPreview(controller!)
              : Center(
                  child: Text(
                    context.loc.mockCameraPreview(cameraLens),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}

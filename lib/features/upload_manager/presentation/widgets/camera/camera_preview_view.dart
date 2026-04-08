import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '/features/upload_manager/domain/repositories/camera_repository.dart';

class CameraPreviewView extends StatelessWidget {
  const CameraPreviewView({
    required this.controller,
    required this.onTapPoint,
    required this.onScaleStart,
    required this.onScaleUpdate,
    super.key,
  });

  final CameraController? controller;
  final ValueChanged<FocusPoint> onTapPoint;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onTapUp: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null || box.size.width == 0 || box.size.height == 0) {
          return;
        }
        final local = box.globalToLocal(details.globalPosition);
        onTapPoint(
          FocusPoint(
            x: (local.dx / box.size.width).clamp(0, 1),
            y: (local.dy / box.size.height).clamp(0, 1),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0F172A),
        child: controller != null && controller!.value.isInitialized
            ? ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller!.value.previewSize?.height ?? 1080,
                    height: controller!.value.previewSize?.width ?? 1920,
                    child: CameraPreview(controller!),
                  ),
                ),
              )
            : const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF415B60), Color(0xFF1C272A)],
                  ),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '/features/upload_manager/domain/repositories/camera_repository.dart';

class FocusIndicator extends StatelessWidget {
  const FocusIndicator({required this.focusPoint, super.key});

  final FocusPoint? focusPoint;

  @override
  Widget build(BuildContext context) {
    if (focusPoint == null) {
      return const SizedBox.shrink();
    }

    final alignment = Alignment(
      (focusPoint!.x * 2) - 1,
      (focusPoint!.y * 2) - 1,
    );

    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

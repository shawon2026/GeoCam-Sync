import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

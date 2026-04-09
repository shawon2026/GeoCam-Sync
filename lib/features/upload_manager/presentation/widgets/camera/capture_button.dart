import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return GestureDetector(
      onTap: isCapturing ? null : onPressed,
      child: Container(
        width: 84.w,
        height: 84.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 4),
          color: Colors.white.withValues(alpha: 0.12),
        ),
        padding: EdgeInsets.all(8.r),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCapturing ? const Color(0xFF94A3B8) : Colors.white,
          ),
        ),
      ),
    );
  }
}

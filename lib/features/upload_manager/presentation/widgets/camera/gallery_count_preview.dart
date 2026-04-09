import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

class GalleryCountPreview extends StatelessWidget {
  const GalleryCountPreview({
    required this.count,
    required this.onTap,
    super.key,
  });

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 2.w,
              ),
              color: Colors.white.withValues(alpha: 0.78),
            ),
            child: const Icon(
              Icons.photo_camera_back_outlined,
              color: Color(0xFF374151),
            ),
          ),
          if (count > 0)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2563EB),
                ),
                alignment: Alignment.center,
                child: GlobalText.raw(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

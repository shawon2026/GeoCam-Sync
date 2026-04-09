import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class EmptyUploadState extends StatelessWidget {
  const EmptyUploadState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 12.h),
          GlobalText.raw(
            context.loc.uploadManagerNoUploadsYet,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF334155),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          GlobalText.raw(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14.sp,
              height: 1.45.h,
            ),
          ),
        ],
      ),
    );
  }
}

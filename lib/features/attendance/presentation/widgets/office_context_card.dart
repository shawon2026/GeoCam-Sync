import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class OfficeContextCard extends StatelessWidget {
  const OfficeContextCard({
    required this.hasOfficeLocation,
    required this.onSetOfficeLocation,
    this.officeCoordinateText,
    super.key,
  });

  final bool hasOfficeLocation;
  final String? officeCoordinateText;
  final VoidCallback onSetOfficeLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            str: context.loc.attendanceStepOfficeContext,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 126.h,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D9E3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDDE7EE), Color(0xFFC5D4E0)],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.my_location,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        SizedBox(width: 6.w),
                        GlobalText.raw(
                          officeCoordinateText ??
                              context.loc.officeLocationNotSet,
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GlobalText(
            str: context.loc.attendanceOfficeHint,
            fontSize: 13.sp,
            color: const Color(0xFF64748B),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSetOfficeLocation,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: const Color(0xFF2563EB), width: 1.5.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              label: GlobalText.raw(
                hasOfficeLocation
                    ? context.loc.updateOfficeLocation
                    : context.loc.setOfficeLocation,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

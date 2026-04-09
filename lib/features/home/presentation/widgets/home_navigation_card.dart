import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

class HomeNavigationCard extends StatelessWidget {
  const HomeNavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonLabel,
    required this.accentColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonLabel;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: accentColor),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GlobalText(
                  str: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          GlobalText(
            str: subtitle,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569),
            height: 1.35.h,
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: GlobalText.raw(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

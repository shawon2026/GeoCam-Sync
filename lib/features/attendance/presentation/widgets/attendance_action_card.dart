import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

class AttendanceActionCard extends StatelessWidget {
  const AttendanceActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.enabled,
    required this.isLoading,
    required this.onMark,
    required this.availabilityText,
    this.markedAtText,
    this.isLateAction = false,
    this.isMarked = false,
    this.isMarkedLate = false,
    this.showLockIcon = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onMark;
  final String availabilityText;
  final String? markedAtText;
  final bool isLateAction;
  final bool isMarked;
  final bool isMarkedLate;
  final bool showLockIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: enabled ? const Color(0xFFD1D5DB) : const Color(0xFFCBD5E1),
          width: 1.2.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLockIcon) ...[
            const Center(
              child: Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8)),
            ),
            SizedBox(height: 8.h),
          ],
          GlobalText(
            str: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: _titleColor(),
            textAlign: TextAlign.center,
          ),
          if (subtitle.trim().isNotEmpty) ...[
            SizedBox(height: 6.h),
            GlobalText(
              str: subtitle,
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 14.h),
          if (markedAtText != null && markedAtText!.trim().isNotEmpty) ...[
            GlobalText.raw(
              markedAtText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: enabled && !isLoading ? onMark : null,
              // Keep marked state visually explicit even when disabled.
              style: FilledButton.styleFrom(
                backgroundColor: _buttonColor(enabled: enabled),
                disabledBackgroundColor: _buttonColor(enabled: false),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: GlobalText.raw(
                buttonLabel,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: GlobalText.raw(
              availabilityText,
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _titleColor() {
    if (isMarked) {
      return isMarkedLate ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
    }
    if (isLateAction) {
      return const Color(0xFFDC2626);
    }
    return null;
  }

  Color _buttonColor({required bool enabled}) {
    if (isMarked) {
      return isMarkedLate ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
    }
    return enabled ? const Color(0xFF2563EB) : const Color(0xFFB7C3D2);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_time_helper.dart';
import '/core/utils/extension.dart';
import '/features/attendance/domain/entities/attendance_record.dart';

class AttendanceHistoryCard extends StatelessWidget {
  const AttendanceHistoryCard({required this.item, super.key});

  final AttendanceRecordEntity item;

  @override
  Widget build(BuildContext context) {
    final isLate = item.status == AttendanceMarkStatus.late;
    final statusColor = isLate
        ? AppColors.warning.color
        : AppColors.success.color;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.white.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                isLate ? Icons.schedule_rounded : Icons.check_circle_rounded,
                color: statusColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.raw(
                    isLate
                        ? context.loc.lateAttendanceMarked
                        : context.loc.attendanceMarked,
                    style: TextStyle(
                      color: AppColors.textPrimary.color,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  GlobalText.raw(
                    DateTimeHelper.toDateTimeLabel(item.markedAt),
                    style: TextStyle(
                      color: AppColors.textSecondary.color,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _HistoryChip(
                        icon: Icons.social_distance_rounded,
                        label: '${item.distanceMeters.toStringAsFixed(1)} m',
                      ),
                      _HistoryChip(
                        icon: Icons.calendar_today_rounded,
                        label: item.attendanceDate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.background.color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary.color),
          SizedBox(width: 6.w),
          GlobalText.raw(
            label,
            style: TextStyle(
              color: AppColors.textPrimary.color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

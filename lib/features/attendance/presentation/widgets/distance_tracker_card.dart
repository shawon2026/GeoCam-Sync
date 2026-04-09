import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/constants/attendance_constants.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';
import '/core/utils/location_color_helper.dart';

class DistanceTrackerCard extends StatelessWidget {
  const DistanceTrackerCard({
    required this.distanceMeters,
    required this.inRange,
    super.key,
  });

  final double distanceMeters;
  final bool inRange;

  @override
  Widget build(BuildContext context) {
    final color = LocationColorHelper.byDistance(distanceMeters);
    final statusText = inRange
        ? context.loc.attendanceInRangeLabel
        : context.loc.attendanceOutOfRangeLabel;
    final distanceText = distanceMeters.isFinite
        ? '${distanceMeters.toStringAsFixed(0)}m'
        : '--';

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 136.w,
            height: 136.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: CircularProgressIndicator(
                    value: 0.82,
                    strokeWidth: 4,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                GlobalText.raw(
                  distanceText,
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999.r),
              color: color.withValues(alpha: 0.10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: color),
                SizedBox(width: 6.w),
                GlobalText.raw(
                  statusText,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          GlobalText(
            str: inRange
                ? context.loc.attendanceReady
                : context.loc.moveWithinRangeDynamic(_rangeMetersLabel),
            fontSize: 12.sp,
            textAlign: TextAlign.center,
            color: const Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}

String get _rangeMetersLabel =>
    AttendanceConstants.inRangeThresholdMeters.value.toStringAsFixed(0);

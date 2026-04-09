import '/core/constants/attendance_constants.dart';
import '/core/utils/date_time_helper.dart';
import '/features/attendance/domain/entities/attendance_eligibility.dart';
import '/features/attendance/domain/entities/attendance_record.dart';

class CheckAttendanceEligibilityParams {
  const CheckAttendanceEligibilityParams({
    required this.distanceMeters,
    required this.todayRecord,
  });

  final double distanceMeters;
  final AttendanceRecordEntity? todayRecord;
}

class CheckAttendanceEligibility {
  AttendanceEligibility call(CheckAttendanceEligibilityParams params) {
    final inRange =
        params.distanceMeters <=
        AttendanceConstants.inRangeThresholdMeters.value;
    final alreadyMarked = params.todayRecord != null;
    final isLate = DateTimeHelper.isLate(DateTimeHelper.now());

    final canMarkNow = inRange && !alreadyMarked;

    return AttendanceEligibility(
      inRange: inRange,
      canMarkNow: canMarkNow,
      isLate: isLate,
      isAlreadyMarked: alreadyMarked,
      markedRecord: params.todayRecord,
    );
  }
}

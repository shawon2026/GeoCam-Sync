import 'package:intl/intl.dart';
import '/core/constants/attendance_constants.dart';

class DateTimeHelper {
  DateTimeHelper._();

  static DateTime now() => DateTime.now();

  static DateTime startWindow(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      AttendanceConstants.attendanceStartHour,
      AttendanceConstants.attendanceStartMinute,
    );
  }

  static DateTime lateWindow(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      AttendanceConstants.lateThresholdHour,
      AttendanceConstants.lateThresholdMinute,
    );
  }

  static bool isLate(DateTime dateTime) {
    return dateTime.isAfter(lateWindow(dateTime));
  }

  static String toDateKey(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String toDateTimeLabel(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
}

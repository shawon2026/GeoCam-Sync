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
      AttendanceConstants.attendanceStartHour.value.toInt(),
      AttendanceConstants.attendanceStartMinute.value.toInt(),
    );
  }

  static DateTime lateWindow(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      AttendanceConstants.lateThresholdHour.value.toInt(),
      AttendanceConstants.lateThresholdMinute.value.toInt(),
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

  static String toWindowTimeLabel({
    required int hour,
    required int minute,
    DateTime? baseDate,
  }) {
    final date = baseDate ?? now();
    final value = DateTime(date.year, date.month, date.day, hour, minute);
    return DateFormat('hh:mm a').format(value);
  }
}

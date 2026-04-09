enum AttendanceConstants {
  inRangeThresholdMeters(50),
  warningRangeThresholdMeters(100),
  preciseLocationMaxAccuracyMeters(100),
  attendanceStartHour(9),
  attendanceStartMinute(0),
  lateThresholdHour(10),
  lateThresholdMinute(30);

  final num value;
  const AttendanceConstants(this.value);
}

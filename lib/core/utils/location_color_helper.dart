import 'package:flutter/material.dart';
import '/core/constants/attendance_constants.dart';

class LocationColorHelper {
  LocationColorHelper._();

  static Color byDistance(double distanceMeters) {
    if (distanceMeters <= AttendanceConstants.inRangeThresholdMeters.value) {
      return const Color(0xFF16A34A);
    }
    if (distanceMeters <=
        AttendanceConstants.warningRangeThresholdMeters.value) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFDC2626);
  }
}

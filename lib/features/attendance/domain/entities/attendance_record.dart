import 'package:equatable/equatable.dart';

enum AttendanceMarkStatus { present, late }

class AttendanceRecordEntity extends Equatable {
  const AttendanceRecordEntity({
    required this.attendanceDate,
    required this.markedAt,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
  });

  final String attendanceDate;
  final DateTime markedAt;
  final AttendanceMarkStatus status;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  @override
  List<Object?> get props => [
    attendanceDate,
    markedAt,
    status,
    latitude,
    longitude,
    distanceMeters,
  ];
}

import 'package:drift/drift.dart' as drift;
import '/db/app_database.dart';
import '/features/attendance/domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.attendanceDate,
    required super.markedAt,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.distanceMeters,
  });

  factory AttendanceRecordModel.fromDb(AttendanceRecord row) {
    return AttendanceRecordModel(
      attendanceDate: row.attendanceDate,
      markedAt: DateTime.parse(row.markedAt),
      status: row.status == 'late'
          ? AttendanceMarkStatus.late
          : AttendanceMarkStatus.present,
      latitude: row.latitude,
      longitude: row.longitude,
      distanceMeters: row.distanceMeters,
    );
  }

  AttendanceRecordsCompanion toCompanion() {
    return AttendanceRecordsCompanion(
      attendanceDate: drift.Value(attendanceDate),
      markedAt: drift.Value(markedAt.toIso8601String()),
      status: drift.Value(status.name),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      distanceMeters: drift.Value(distanceMeters),
    );
  }
}

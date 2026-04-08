import 'package:drift/drift.dart';

class AttendanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get attendanceDate => text().unique()();

  TextColumn get markedAt => text()();

  TextColumn get status => text()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();

  RealColumn get distanceMeters => real()();
}

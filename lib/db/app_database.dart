import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '/db/tables/attendance_records_table.dart';
import '/db/tables/office_config_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AttendanceRecords, OfficeConfigs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'geocam_sync_db'));

  @override
  int get schemaVersion => 1;

  Future<AttendanceRecord?> getAttendanceByDate(String dateKey) {
    return (select(
      attendanceRecords,
    )..where((tbl) => tbl.attendanceDate.equals(dateKey))).getSingleOrNull();
  }

  Future<int> upsertAttendance(AttendanceRecordsCompanion companion) {
    return into(attendanceRecords).insertOnConflictUpdate(companion);
  }

  Stream<List<AttendanceRecord>> watchAttendanceHistory() {
    return (select(attendanceRecords)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.markedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<OfficeConfig?> getOfficeConfig() {
    return (select(
      officeConfigs,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
  }

  Future<int> upsertOfficeConfig(OfficeConfigsCompanion companion) {
    return into(officeConfigs).insertOnConflictUpdate(companion);
  }

  Future<void> clearAttendance() async {
    await delete(attendanceRecords).go();
  }

  Future<void> clearOfficeConfig() async {
    await delete(officeConfigs).go();
  }
}

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '/db/converters/upload_status_converter.dart';
import '/db/tables/attendance_records_table.dart';
import '/db/tables/office_config_table.dart';
import '/db/tables/upload_batches_table.dart';
import '/db/tables/upload_items_table.dart';
import '/features/upload_manager/domain/entities/upload_item.dart' as domain;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [AttendanceRecords, OfficeConfigs, UploadBatches, UploadItems],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'geocam_sync_db'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(uploadBatches);
        await m.createTable(uploadItems);
      }
    },
  );

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

  Future<void> createUploadBatch(UploadBatchesCompanion companion) async {
    await into(uploadBatches).insertOnConflictUpdate(companion);
  }

  Future<void> upsertUploadItem(UploadItemsCompanion companion) async {
    await into(uploadItems).insertOnConflictUpdate(companion);
  }

  Future<UploadBatchRow?> getUploadBatch(String id) {
    return (select(
      uploadBatches,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<UploadItemRow>> getUploadItems() {
    return (select(uploadItems)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Stream<List<UploadItemRow>> watchUploadItems() {
    return (select(uploadItems)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<void> updateUploadItemStatus({
    required String id,
    required domain.UploadItemStatus status,
    double? progress,
    int? retryCount,
  }) async {
    await (update(uploadItems)..where((tbl) => tbl.id.equals(id))).write(
      UploadItemsCompanion(
        status: Value(status),
        progress: progress == null ? const Value.absent() : Value(progress),
        retryCount: retryCount == null
            ? const Value.absent()
            : Value(retryCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateUploadBatchCounts({
    required String id,
    required int uploadedCount,
    required int pendingCount,
    required String status,
  }) async {
    await (update(uploadBatches)..where((tbl) => tbl.id.equals(id))).write(
      UploadBatchesCompanion(
        uploadedCount: Value(uploadedCount),
        pendingCount: Value(pendingCount),
        status: Value(status),
      ),
    );
  }

  Future<void> deleteUploadItem(String id) async {
    await (delete(uploadItems)..where((tbl) => tbl.id.equals(id))).go();
  }
}

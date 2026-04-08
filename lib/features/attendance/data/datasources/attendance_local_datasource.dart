import '/core/utils/date_time_helper.dart';
import '/db/app_database.dart';
import '/features/attendance/data/models/attendance_record_model.dart';
import '/features/attendance/data/models/office_location_model.dart';

abstract class AttendanceLocalDataSource {
  Future<OfficeLocationModel?> getOfficeLocation();

  Future<void> saveOfficeLocation(OfficeLocationModel model);

  Future<AttendanceRecordModel?> getTodayAttendance();

  Future<void> saveAttendance(AttendanceRecordModel model);

  Stream<List<AttendanceRecordModel>> watchAttendanceHistory();
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  AttendanceLocalDataSourceImpl({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Future<OfficeLocationModel?> getOfficeLocation() async {
    final config = await _database.getOfficeConfig();
    if (config == null) return null;
    return OfficeLocationModel.fromDb(config);
  }

  @override
  Future<void> saveOfficeLocation(OfficeLocationModel model) async {
    await _database.upsertOfficeConfig(model.toCompanion());
  }

  @override
  Future<AttendanceRecordModel?> getTodayAttendance() async {
    final row = await _database.getAttendanceByDate(
      DateTimeHelper.toDateKey(DateTimeHelper.now()),
    );
    if (row == null) return null;
    return AttendanceRecordModel.fromDb(row);
  }

  @override
  Future<void> saveAttendance(AttendanceRecordModel model) async {
    await _database.upsertAttendance(model.toCompanion());
  }

  @override
  Stream<List<AttendanceRecordModel>> watchAttendanceHistory() {
    return _database.watchAttendanceHistory().map(
      (rows) => rows.map(AttendanceRecordModel.fromDb).toList(),
    );
  }
}

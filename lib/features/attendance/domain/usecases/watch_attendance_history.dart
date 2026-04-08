import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class WatchAttendanceHistory {
  WatchAttendanceHistory(this._repository);

  final AttendanceRepository _repository;

  Stream<List<AttendanceRecordEntity>> call() {
    return _repository.watchAttendanceHistory();
  }
}

import '/features/attendance/domain/repositories/attendance_repository.dart';

class WatchLiveDistance {
  WatchLiveDistance(this._repository);

  final AttendanceRepository _repository;

  Stream<double> call() {
    return _repository.watchDistanceToOffice();
  }
}

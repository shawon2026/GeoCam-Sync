import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class GetTodayAttendance extends UseCase<AttendanceRecordEntity?, NoParams> {
  GetTodayAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecordEntity?>> call(NoParams params) {
    return _repository.getTodayAttendance();
  }
}

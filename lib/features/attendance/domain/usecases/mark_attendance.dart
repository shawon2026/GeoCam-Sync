import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class MarkAttendanceParams {
  const MarkAttendanceParams({
    required this.isLate,
    required this.distanceMeters,
  });

  final bool isLate;
  final double distanceMeters;
}

class MarkAttendance
    extends UseCase<AttendanceRecordEntity, MarkAttendanceParams> {
  MarkAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecordEntity>> call(
    MarkAttendanceParams params,
  ) {
    return _repository.markAttendance(
      isLate: params.isLate,
      distanceMeters: params.distanceMeters,
    );
  }
}

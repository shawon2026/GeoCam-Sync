import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class IsPreciseLocationPermissionGranted extends UseCase<bool, NoParams> {
  IsPreciseLocationPermissionGranted(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isPrecisePermissionGranted();
  }
}

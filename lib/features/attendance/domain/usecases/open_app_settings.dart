import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class OpenAppSettings extends UseCase<void, NoParams> {
  OpenAppSettings(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.openAppSettings();
  }
}

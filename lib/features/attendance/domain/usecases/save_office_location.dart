import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/entities/office_location.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class SaveOfficeLocation extends UseCase<OfficeLocation, NoParams> {
  SaveOfficeLocation(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, OfficeLocation>> call(NoParams params) {
    return _repository.saveOfficeLocationFromCurrent();
  }
}

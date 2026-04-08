import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class GetDistanceToOffice extends UseCase<double, NoParams> {
  GetDistanceToOffice(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, double>> call(NoParams params) {
    return _repository.getDistanceToOffice();
  }
}

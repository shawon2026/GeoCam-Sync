import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/home/domain/entities/home.dart';
import '/features/home/domain/repositories/home_repository.dart';

/// Use case for getting paginated Home
class GetHome implements UseCase<List<Home>, NoParams> {
  final HomeRepository _repository;

  GetHome(this._repository);

  @override
  Future<Either<Failure, List<Home>>> call(NoParams params) async {
    return await _repository.getHome();
  }
}

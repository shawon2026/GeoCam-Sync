import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/home/domain/entities/home.dart';

/// Repository interface for Home functionality
abstract class HomeRepository {
  /// Get paginated list of Home
  Future<Either<Failure, List<Home>>> getHome();
}

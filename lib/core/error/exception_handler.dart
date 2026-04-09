import 'package:dartz/dartz.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Converts exceptions to failures - use this in all repository methods
///
/// Usage:
/// ```dart
/// @override
/// Future<Either<Failure, LoginResponse>> login(LoginEntity entity) async {
///   return handleException(() async {
///     final response = await remoteDataSource.login(model);
///     await localDataSource.saveLoginData(response);
///     return response;  // Just return the data, not Right()
///   });
/// }
/// ```
Future<Either<Failure, T>> handleException<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } on CacheException catch (e) {
    return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
  } on LocationPermissionException catch (e) {
    return Left(
      ValidationFailure(message: e.message, statusCode: e.statusCode),
    );
  } on LocationServiceException catch (e) {
    return Left(
      ValidationFailure(message: e.message, statusCode: e.statusCode),
    );
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}

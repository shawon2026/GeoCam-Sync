import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/entities/home.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<Home>>> getHome() async {
    return handleException(() async {
      final remoteHome = await _remoteDataSource.getHome();
      await _localDataSource.cacheHome(remoteHome);
      return remoteHome;
    });
  }
}




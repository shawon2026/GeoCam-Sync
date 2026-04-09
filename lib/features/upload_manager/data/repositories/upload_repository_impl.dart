import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/upload_manager/data/datasources/local_upload_datasource.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  UploadRepositoryImpl({required LocalUploadDataSource localDataSource})
    : _localDataSource = localDataSource;

  final LocalUploadDataSource _localDataSource;

  @override
  Future<Either<Failure, UploadBatch>> addFilesToQueue(
    String batchId,
    List<CameraCapture> captures,
  ) async {
    try {
      return Right(await _localDataSource.addFilesToQueue(batchId, captures));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadBatch>> createUploadBatch() async {
    try {
      return Right(await _localDataSource.createBatch());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSyncedFileLocally(String itemId) async {
    try {
      await _localDataSource.deleteSyncedFileLocally(itemId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UploadItem>>> getPendingUploads() async {
    try {
      return Right(await _localDataSource.getPendingUploads());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadProgress>> getUploadSummary() async {
    try {
      return Right(await _localDataSource.getUploadSummary());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> pauseAllUploads() async {
    try {
      await _localDataSource.pauseAllUploads();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resumeAllUploads() async {
    try {
      await _localDataSource.resumeAllUploads();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<UploadItem>> watchPendingUploads() {
    return _localDataSource.watchPendingUploads();
  }
}

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
    return Right(await _localDataSource.addFilesToQueue(batchId, captures));
  }

  @override
  Future<Either<Failure, UploadBatch>> createUploadBatch() async {
    return Right(await _localDataSource.createBatch());
  }

  @override
  Future<Either<Failure, Unit>> deleteSyncedFileLocally(String itemId) async {
    await _localDataSource.deleteSyncedFileLocally(itemId);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<UploadItem>>> getPendingUploads() async {
    return Right(await _localDataSource.getPendingUploads());
  }

  @override
  Future<Either<Failure, UploadProgress>> getUploadSummary() async {
    return Right(await _localDataSource.getUploadSummary());
  }

  @override
  Future<Either<Failure, Unit>> pauseAllUploads() async {
    await _localDataSource.pauseAllUploads();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> resumeAllUploads() async {
    await _localDataSource.resumeAllUploads();
    return const Right(unit);
  }

  @override
  Stream<List<UploadItem>> watchPendingUploads() {
    return _localDataSource.watchPendingUploads();
  }
}

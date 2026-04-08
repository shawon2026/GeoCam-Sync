import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';

abstract class UploadRepository {
  Future<Either<Failure, UploadBatch>> createUploadBatch();

  Future<Either<Failure, UploadBatch>> addFilesToQueue(
    String batchId,
    List<CameraCapture> captures,
  );

  Future<Either<Failure, List<UploadItem>>> getPendingUploads();

  Future<Either<Failure, UploadProgress>> getUploadSummary();

  Future<Either<Failure, Unit>> pauseAllUploads();

  Future<Either<Failure, Unit>> resumeAllUploads();

  Future<Either<Failure, Unit>> deleteSyncedFileLocally(String itemId);

  Stream<List<UploadItem>> watchPendingUploads();
}

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/upload_manager/domain/entities/sync_status.dart';

abstract class SyncRepository {
  Future<Either<Failure, Unit>> startBackgroundSync();

  Future<Either<Failure, Unit>> retryFailedUploads();

  Future<Either<Failure, Unit>> processUploadQueue();

  Stream<SyncStatus> watchSyncStatus();

  Future<Either<Failure, Unit>> handleNetworkRecovery();
}

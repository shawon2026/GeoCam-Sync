import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';

class RetryFailedUploads extends UseCase<Unit, NoParams> {
  RetryFailedUploads(this.repository);

  final SyncRepository repository;

  @override
  call(NoParams params) {
    return repository.retryFailedUploads();
  }
}

import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';

class ProcessUploadQueue extends UseCase<Unit, NoParams> {
  ProcessUploadQueue(this.repository);

  final SyncRepository repository;

  @override
  call(NoParams params) {
    return repository.processUploadQueue();
  }
}

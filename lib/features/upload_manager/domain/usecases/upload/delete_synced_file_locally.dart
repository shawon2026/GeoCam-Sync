import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class DeleteSyncedFileLocally extends UseCase<Unit, String> {
  DeleteSyncedFileLocally(this.repository);

  final UploadRepository repository;

  @override
  call(String params) {
    return repository.deleteSyncedFileLocally(params);
  }
}

import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class PauseAllUploads extends UseCase<Unit, NoParams> {
  PauseAllUploads(this.repository);

  final UploadRepository repository;

  @override
  call(NoParams params) {
    return repository.pauseAllUploads();
  }
}

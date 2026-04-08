import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class ResumeAllUploads extends UseCase<Unit, NoParams> {
  ResumeAllUploads(this.repository);

  final UploadRepository repository;

  @override
  call(NoParams params) {
    return repository.resumeAllUploads();
  }
}

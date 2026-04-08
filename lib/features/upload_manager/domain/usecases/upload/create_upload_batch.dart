import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class CreateUploadBatch extends UseCase<UploadBatch, NoParams> {
  CreateUploadBatch(this.repository);

  final UploadRepository repository;

  @override
  call(NoParams params) {
    return repository.createUploadBatch();
  }
}

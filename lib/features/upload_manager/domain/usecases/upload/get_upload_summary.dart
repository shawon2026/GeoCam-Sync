import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class GetUploadSummary extends UseCase<UploadProgress, NoParams> {
  GetUploadSummary(this.repository);

  final UploadRepository repository;

  @override
  call(NoParams params) {
    return repository.getUploadSummary();
  }
}

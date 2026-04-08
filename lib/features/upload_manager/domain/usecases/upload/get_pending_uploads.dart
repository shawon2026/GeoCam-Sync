import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class GetPendingUploads extends UseCase<List<UploadItem>, NoParams> {
  GetPendingUploads(this.repository);

  final UploadRepository repository;

  @override
  call(NoParams params) {
    return repository.getPendingUploads();
  }
}

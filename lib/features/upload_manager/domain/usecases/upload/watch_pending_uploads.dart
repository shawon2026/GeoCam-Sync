import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class WatchPendingUploads {
  WatchPendingUploads(this.repository);

  final UploadRepository repository;

  Stream<List<UploadItem>> call() {
    return repository.watchPendingUploads();
  }
}

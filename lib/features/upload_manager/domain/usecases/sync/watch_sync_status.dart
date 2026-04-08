import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';

class WatchSyncStatus {
  WatchSyncStatus(this.repository);

  final SyncRepository repository;

  Stream<SyncStatus> call() {
    return repository.watchSyncStatus();
  }
}

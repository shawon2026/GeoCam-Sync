import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';

class StartBackgroundSync extends UseCase<Unit, NoParams> {
  StartBackgroundSync(this.repository);

  final SyncRepository repository;

  @override
  call(NoParams params) {
    return repository.startBackgroundSync();
  }
}

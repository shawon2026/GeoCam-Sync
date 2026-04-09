import 'package:workmanager/workmanager.dart';

import '/core/di/service_locator.dart';
import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/usecases/sync/process_upload_queue.dart';

const String uploadSyncTaskName = 'geocam_upload_sync';
const String uploadSyncUniqueName =
    'com.intelligentmachines.geocam_sync.upload.sync';

@pragma('vm:entry-point')
void uploadWorkerDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (!sl.isRegistered<ProcessUploadQueue>()) {
      await initDependencies();
    }
    final useCase = sl<ProcessUploadQueue>();
    final result = await useCase(NoParams());
    return result.isRight();
  });
}

class BackgroundWorkerService {
  const BackgroundWorkerService();

  Future<void> initialize() async {
    await Workmanager().initialize(uploadWorkerDispatcher);
  }

  Future<void> registerUploadWorker() async {
    await Workmanager().registerPeriodicTask(
      uploadSyncTaskName,
      uploadSyncUniqueName,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> triggerUploadProcessing() async {
    await Workmanager().registerOneOffTask(
      '${uploadSyncTaskName}_trigger',
      uploadSyncUniqueName,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

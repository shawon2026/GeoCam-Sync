import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/domain/usecases/sync/handle_network_recovery.dart';
import '/features/upload_manager/domain/usecases/sync/process_upload_queue.dart';
import '/features/upload_manager/domain/usecases/sync/retry_failed_uploads.dart';
import '/features/upload_manager/domain/usecases/sync/start_background_sync.dart';
import '/features/upload_manager/domain/usecases/sync/watch_sync_status.dart';
import 'sync_engine_state.dart';

class SyncEngineCubit extends Cubit<SyncEngineState> {
  SyncEngineCubit({
    required StartBackgroundSync startBackgroundSync,
    required RetryFailedUploads retryFailedUploads,
    required ProcessUploadQueue processUploadQueue,
    required WatchSyncStatus watchSyncStatus,
    required HandleNetworkRecovery handleNetworkRecovery,
  }) : _startBackgroundSync = startBackgroundSync,
       _retryFailedUploads = retryFailedUploads,
       _processUploadQueue = processUploadQueue,
       _watchSyncStatus = watchSyncStatus,
       _handleNetworkRecovery = handleNetworkRecovery,
       super(const SyncEngineState());

  final StartBackgroundSync _startBackgroundSync;
  final RetryFailedUploads _retryFailedUploads;
  final ProcessUploadQueue _processUploadQueue;
  final WatchSyncStatus _watchSyncStatus;
  final HandleNetworkRecovery _handleNetworkRecovery;
  StreamSubscription<SyncStatus>? _statusSubscription;

  Future<void> initialize() async {
    await _startBackgroundSync(NoParams());
    _statusSubscription ??= _watchSyncStatus().listen((status) {
      emit(
        state.copyWith(
          networkState: status.networkState,
          phase: status.phase,
          message: status.message,
          uploadSpeedMbps: status.uploadSpeedMbps,
        ),
      );
    });
  }

  Future<void> processQueue() async {
    await _processUploadQueue(NoParams());
  }

  Future<void> retryFailed() async {
    await _retryFailedUploads(NoParams());
  }

  Future<void> recoverNetwork() async {
    await _handleNetworkRecovery(NoParams());
  }

  @override
  Future<void> close() async {
    await _statusSubscription?.cancel();
    return super.close();
  }
}

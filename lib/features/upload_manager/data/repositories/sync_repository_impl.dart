import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/constants/upload_constants.dart';
import '/core/network/network_state.dart';
import '/core/services/background_worker_service.dart';
import '/features/upload_manager/data/datasources/local_upload_datasource.dart';
import '/features/upload_manager/data/datasources/network_monitor_datasource.dart';
import '/features/upload_manager/data/datasources/remote_upload_datasource.dart';
import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl({
    required NetworkMonitorDataSource networkMonitorDataSource,
    required LocalUploadDataSource localUploadDataSource,
    required RemoteUploadDataSource remoteUploadDataSource,
    required BackgroundWorkerService backgroundWorkerService,
  }) : _networkMonitorDataSource = networkMonitorDataSource,
       _localUploadDataSource = localUploadDataSource,
       _remoteUploadDataSource = remoteUploadDataSource,
       _backgroundWorkerService = backgroundWorkerService {
    _networkSubscription = _networkMonitorDataSource.watchNetworkState().listen(
      (state) async {
        if (!state.canUpload) {
          _statusController.add(
            SyncStatus(
              networkState: state,
              phase: SyncPhase.waiting,
              isBackgroundWorkerRegistered: true,
              message: state == NetworkState.offline
                  ? 'Waiting for internet connection'
                  : 'Waiting for stable bandwidth',
              uploadSpeedMbps: null,
            ),
          );
          return;
        }
        await processUploadQueue();
      },
    );
  }

  final NetworkMonitorDataSource _networkMonitorDataSource;
  final LocalUploadDataSource _localUploadDataSource;
  final RemoteUploadDataSource _remoteUploadDataSource;
  final BackgroundWorkerService _backgroundWorkerService;
  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  late final StreamSubscription<NetworkState> _networkSubscription;
  bool _isProcessing = false;

  @override
  Future<Either<Failure, Unit>> handleNetworkRecovery() async {
    try {
      await retryFailedUploads();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> processUploadQueue() async {
    if (_isProcessing) {
      return const Right(unit);
    }
    _isProcessing = true;
    try {
      final networkState = await _networkMonitorDataSource.getCurrentState();
      if (!networkState.canUpload) {
        await _localUploadDataSource.markActiveItemsWaiting();
        _statusController.add(
          SyncStatus(
            networkState: networkState,
            phase: SyncPhase.waiting,
            isBackgroundWorkerRegistered: true,
            message: 'Waiting for a stable connection',
            uploadSpeedMbps: null,
          ),
        );
        return const Right(unit);
      }

      await _localUploadDataSource.markWaitingItemsPending();
      await _localUploadDataSource.markFailedItemsForRetry();

      while (true) {
        final latestState = await _networkMonitorDataSource.getCurrentState();
        if (!latestState.canUpload) {
          await _localUploadDataSource.markActiveItemsWaiting();
          _statusController.add(
            SyncStatus(
              networkState: latestState,
              phase: SyncPhase.waiting,
              isBackgroundWorkerRegistered: true,
              message: latestState == NetworkState.offline
                  ? 'Waiting for internet connection'
                  : 'Waiting for stable bandwidth',
              uploadSpeedMbps: null,
            ),
          );
          break;
        }

        await _localUploadDataSource.markFirstPendingUploading();
        final uploads = await _localUploadDataSource.getPendingUploads();
        final uploadingItems = uploads.where(
          (entry) => entry.status == UploadItemStatus.uploading,
        );
        final item = uploadingItems.isEmpty ? null : uploadingItems.first;
        if (item == null) {
          break;
        }

        _statusController.add(
          SyncStatus(
            networkState: latestState,
            phase: SyncPhase.uploading,
            isBackgroundWorkerRegistered: true,
            message: 'Uploading ${item.fileName}',
            uploadSpeedMbps: _speedFor(latestState),
          ),
        );

        try {
          await _remoteUploadDataSource.upload(item);
          await _localUploadDataSource.markFirstUploadingSynced();
          await _localUploadDataSource.cleanupSyncedSourceFile(item.id);
        } on DummyUploadException catch (error) {
          if (error.isNetworkIssue) {
            await _localUploadDataSource.markActiveItemsWaiting();
            _statusController.add(
              SyncStatus(
                networkState: NetworkState.unstable,
                phase: SyncPhase.waiting,
                isBackgroundWorkerRegistered: true,
                message: 'Waiting (Network Issue)',
                uploadSpeedMbps: null,
              ),
            );
            await Future<void>.delayed(
              Duration(
                seconds: UploadConstants.retryDelaySeconds.value.toInt(),
              ),
            );
            await _localUploadDataSource.markWaitingItemsPending();
            continue;
          }

          await _localUploadDataSource.markCurrentUploadingFailed();
          _statusController.add(
            SyncStatus(
              networkState: networkState,
              phase: SyncPhase.retrying,
              isBackgroundWorkerRegistered: true,
              message: 'Retrying ${item.fileName}',
              uploadSpeedMbps: null,
            ),
          );
          await Future<void>.delayed(
            Duration(seconds: UploadConstants.retryDelaySeconds.value.toInt()),
          );
          await _localUploadDataSource.markFailedItemsForRetry();
          continue;
        } catch (_) {
          await _localUploadDataSource.markCurrentUploadingFailed();
          _statusController.add(
            SyncStatus(
              networkState: networkState,
              phase: SyncPhase.retrying,
              isBackgroundWorkerRegistered: true,
              message: 'Retrying ${item.fileName}',
              uploadSpeedMbps: null,
            ),
          );
          await Future<void>.delayed(
            Duration(seconds: UploadConstants.retryDelaySeconds.value.toInt()),
          );
          await _localUploadDataSource.markFailedItemsForRetry();
          continue;
        }
      }

      final remainingItems = await _localUploadDataSource.getPendingUploads();
      final hasWork = remainingItems.any(
        (item) => item.status != UploadItemStatus.synced,
      );
      final hasPausedOnly =
          hasWork &&
          remainingItems
              .where((item) => item.status != UploadItemStatus.synced)
              .every((item) => item.status == UploadItemStatus.paused);
      final finalState = await _networkMonitorDataSource.getCurrentState();
      _statusController.add(
        SyncStatus(
          networkState: finalState,
          phase: !hasWork
              ? SyncPhase.completed
              : hasPausedOnly
              ? SyncPhase.paused
              : (finalState.canUpload ? SyncPhase.idle : SyncPhase.waiting),
          isBackgroundWorkerRegistered: true,
          message: !hasWork
              ? 'All uploads synced'
              : hasPausedOnly
              ? 'Uploads paused by user'
              : (finalState.canUpload
                    ? 'Queue is ready for the next upload'
                    : 'Waiting for stable connection'),
          uploadSpeedMbps: null,
        ),
      );
      return const Right(unit);
    } catch (e) {
      _statusController.add(
        const SyncStatus(
          networkState: NetworkState.unstable,
          phase: SyncPhase.waiting,
          isBackgroundWorkerRegistered: true,
          message: 'Sync failed, waiting for retry',
          uploadSpeedMbps: null,
        ),
      );
      return Left(ServerFailure(message: e.toString()));
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Future<Either<Failure, Unit>> retryFailedUploads() async {
    try {
      await _localUploadDataSource.markFailedItemsForRetry();
      _statusController.add(
        const SyncStatus(
          networkState: NetworkState.unstable,
          phase: SyncPhase.retrying,
          isBackgroundWorkerRegistered: true,
          message: 'Retrying failed uploads',
          uploadSpeedMbps: null,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> startBackgroundSync() async {
    try {
      await _backgroundWorkerService.registerUploadWorker();
      await _backgroundWorkerService.triggerUploadProcessing();
      _statusController.add(
        const SyncStatus(
          networkState: NetworkState.stable,
          phase: SyncPhase.idle,
          isBackgroundWorkerRegistered: true,
          message: 'Background sync is ready',
          uploadSpeedMbps: null,
        ),
      );
      return const Right(unit);
    } catch (e) {
      _statusController.add(
        const SyncStatus(
          networkState: NetworkState.unstable,
          phase: SyncPhase.waiting,
          isBackgroundWorkerRegistered: false,
          message: 'Background sync setup failed',
          uploadSpeedMbps: null,
        ),
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<SyncStatus> watchSyncStatus() {
    _networkSubscription.isPaused;
    return _statusController.stream;
  }

  double _speedFor(NetworkState state) {
    final base = state == NetworkState.stable ? 18.5 : 6.2;
    return max(0.8, base);
  }
}

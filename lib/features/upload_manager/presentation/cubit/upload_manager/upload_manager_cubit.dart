import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/usecases/upload/delete_synced_file_locally.dart';
import '/features/upload_manager/domain/usecases/upload/get_upload_summary.dart';
import '/features/upload_manager/domain/usecases/upload/pause_all_uploads.dart';
import '/features/upload_manager/domain/usecases/upload/resume_all_uploads.dart';
import '/features/upload_manager/domain/usecases/upload/watch_pending_uploads.dart';
import 'upload_manager_state.dart';

class UploadManagerCubit extends Cubit<UploadManagerState> {
  UploadManagerCubit({
    required GetUploadSummary getUploadSummary,
    required WatchPendingUploads watchPendingUploads,
    required PauseAllUploads pauseAllUploads,
    required ResumeAllUploads resumeAllUploads,
    required DeleteSyncedFileLocally deleteSyncedFileLocally,
  }) : _getUploadSummary = getUploadSummary,
       _watchPendingUploads = watchPendingUploads,
       _pauseAllUploads = pauseAllUploads,
       _resumeAllUploads = resumeAllUploads,
       _deleteSyncedFileLocally = deleteSyncedFileLocally,
       super(const UploadManagerState());

  final GetUploadSummary _getUploadSummary;
  final WatchPendingUploads _watchPendingUploads;
  final PauseAllUploads _pauseAllUploads;
  final ResumeAllUploads _resumeAllUploads;
  final DeleteSyncedFileLocally _deleteSyncedFileLocally;
  StreamSubscription<List<UploadItem>>? _itemsSubscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, message: null));
    _itemsSubscription ??= _watchPendingUploads().listen((items) async {
      final summaryResult = await _getUploadSummary(NoParams());
      summaryResult.fold(
        (_) => emit(state.copyWith(items: items, isLoading: false)),
        (summary) => emit(
          state.copyWith(items: items, summary: summary, isLoading: false),
        ),
      );
    });
    final summaryResult = await _getUploadSummary(NoParams());
    summaryResult.fold(
      (_) => emit(state.copyWith(isLoading: false)),
      (summary) => emit(state.copyWith(isLoading: false, summary: summary)),
    );
  }

  Future<void> pauseAll() async {
    await _pauseAllUploads(NoParams());
    emit(state.copyWith(isPaused: true, message: 'All uploads paused'));
  }

  Future<void> resumeAll() async {
    await _resumeAllUploads(NoParams());
    emit(state.copyWith(isPaused: false, message: 'Uploads resumed'));
  }

  Future<void> clearSyncedItems(List<String> itemIds) async {
    if (itemIds.isEmpty) {
      return;
    }
    final syncedIds = state.items
        .where((item) => item.status == UploadItemStatus.synced)
        .map((item) => item.id)
        .toSet();
    final uniqueIds = itemIds.toSet().where(syncedIds.contains).toList(
      growable: false,
    );
    if (uniqueIds.isEmpty) {
      return;
    }
    for (final id in uniqueIds) {
      await _deleteSyncedFileLocally(id);
    }
    emit(state.copyWith(message: 'Synced items cleared'));
  }

  Future<void> clearAllSyncedItems() async {
    final syncedIds = state.items
        .where((item) => item.status == UploadItemStatus.synced)
        .map((item) => item.id)
        .toList(growable: false);
    await clearSyncedItems(syncedIds);
  }

  @override
  Future<void> close() async {
    await _itemsSubscription?.cancel();
    return super.close();
  }
}

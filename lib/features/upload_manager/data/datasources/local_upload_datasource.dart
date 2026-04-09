import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;

import '/core/constants/upload_constants.dart';
import '/core/error/exceptions.dart';
import '/core/utils/upload_progress_utils.dart';
import '/db/app_database.dart';
import '/features/upload_manager/data/models/upload_batch_model.dart';
import '/features/upload_manager/data/models/upload_progress_model.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart' as domain;
import '/features/upload_manager/domain/entities/upload_item.dart' as domain;

abstract class LocalUploadDataSource {
  Future<UploadBatchModel> createBatch();

  Future<UploadBatchModel> addFilesToQueue(
    String batchId,
    List<CameraCapture> captures,
  );

  Future<List<domain.UploadItem>> getPendingUploads();

  Stream<List<domain.UploadItem>> watchPendingUploads();

  Future<UploadProgressModel> getUploadSummary();

  Future<void> pauseAllUploads();

  Future<void> resumeAllUploads();

  Future<void> deleteSyncedFileLocally(String itemId);

  Future<void> markFirstPendingUploading();

  Future<void> markFirstUploadingSynced();

  Future<void> markFailedItemsForRetry();

  Future<void> markCurrentUploadingFailed();

  Future<void> markWaitingItemsPending();

  Future<void> markActiveItemsWaiting();
}

class LocalUploadDataSourceImpl implements LocalUploadDataSource {
  LocalUploadDataSourceImpl({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Future<UploadBatchModel> addFilesToQueue(
    String batchId,
    List<CameraCapture> captures,
  ) async {
    final batch = await _database.getUploadBatch(batchId);
    if (batch == null) {
      throw CacheException(message: 'Upload batch not found');
    }

    for (final capture in captures) {
      await _database.upsertUploadItem(
        UploadItemsCompanion.insert(
          id: '${batchId}_${capture.capturedAt.microsecondsSinceEpoch}',
          batchId: batchId,
          localFilePath: capture.localPath,
          thumbnailPath: drift.Value(capture.thumbnailPath),
          fileName: capture.fileName,
          fileSize: capture.fileSize,
          status: domain.UploadItemStatus.pending,
          createdAt: capture.capturedAt,
          updatedAt: capture.capturedAt,
        ),
      );
    }

    final nextTotal = batch.totalItems + captures.length;
    final nextPending = batch.pendingCount + captures.length;
    await _database.updateUploadBatchCounts(
      id: batchId,
      uploadedCount: batch.uploadedCount,
      pendingCount: nextPending,
      status: domain.UploadBatchStatus.queued.name,
    );

    return UploadBatchModel(
      id: batch.id,
      createdAt: batch.createdAt,
      totalItems: nextTotal,
      uploadedCount: batch.uploadedCount,
      pendingCount: nextPending,
      status: domain.UploadBatchStatus.queued,
    );
  }

  @override
  Future<UploadBatchModel> createBatch() async {
    final batch = UploadBatchModel(
      id: 'batch_${DateTime.now().microsecondsSinceEpoch}',
      createdAt: DateTime.now(),
      totalItems: 0,
      uploadedCount: 0,
      pendingCount: 0,
      status: domain.UploadBatchStatus.draft,
    );
    await _database.createUploadBatch(
      UploadBatchesCompanion.insert(
        id: batch.id,
        createdAt: batch.createdAt,
        totalItems: batch.totalItems,
        uploadedCount: drift.Value(batch.uploadedCount),
        pendingCount: drift.Value(batch.pendingCount),
        status: batch.status.name,
      ),
    );
    return batch;
  }

  @override
  Future<void> deleteSyncedFileLocally(String itemId) async {
    final items = await _database.getUploadItems();
    final item = _findById(items, itemId);
    if (item == null) {
      return;
    }
    final file = File(item.localFilePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<domain.UploadItem>> getPendingUploads() async {
    final items = await _database.getUploadItems();
    return _sortItems(items.map(_toDomainItem).toList(growable: false));
  }

  @override
  Future<UploadProgressModel> getUploadSummary() async {
    final items = await _database.getUploadItems();
    final totalItems = items.length;
    final uploadedItems = items
        .where((item) => item.status == domain.UploadItemStatus.synced)
        .length;
    final failedItems = items
        .where((item) => item.status == domain.UploadItemStatus.failed)
        .length;
    final pendingItems = items
        .where((item) => item.status != domain.UploadItemStatus.synced)
        .length;
    return UploadProgressModel(
      totalItems: totalItems,
      pendingItems: pendingItems,
      uploadedItems: uploadedItems,
      failedItems: failedItems,
      completion: UploadProgressUtils.completion(
        totalItems: totalItems,
        uploadedItems: uploadedItems,
      ),
    );
  }

  @override
  Future<void> markFailedItemsForRetry() async {
    final items = await _database.getUploadItems();
    for (final item in items) {
      if (item.status == domain.UploadItemStatus.failed &&
          item.retryCount < UploadConstants.maxRetryCount) {
        await _database.updateUploadItemStatus(
          id: item.id,
          status: domain.UploadItemStatus.pending,
          retryCount: item.retryCount + 1,
        );
      }
    }
  }

  @override
  Future<void> markActiveItemsWaiting() async {
    final items = await _database.getUploadItems();
    for (final item in items) {
      if (item.status == domain.UploadItemStatus.pending ||
          item.status == domain.UploadItemStatus.uploading ||
          item.status == domain.UploadItemStatus.failed) {
        await _database.updateUploadItemStatus(
          id: item.id,
          status: domain.UploadItemStatus.waiting,
        );
      }
    }
  }

  @override
  Future<void> markFirstPendingUploading() async {
    final items = await getPendingUploads();
    final pendingItems = items.where(
      (entry) =>
          entry.status == domain.UploadItemStatus.pending ||
          entry.status == domain.UploadItemStatus.failed ||
          entry.status == domain.UploadItemStatus.waiting,
    );
    final item = pendingItems.isEmpty ? null : pendingItems.first;
    if (item == null) {
      return;
    }
    await _database.updateUploadItemStatus(
      id: item.id,
      status: domain.UploadItemStatus.uploading,
      progress: 0.1,
    );
  }

  @override
  Future<void> markFirstUploadingSynced() async {
    final items = await getPendingUploads();
    final uploadingItems = items.where(
      (entry) => entry.status == domain.UploadItemStatus.uploading,
    );
    final item = uploadingItems.isEmpty ? null : uploadingItems.first;
    if (item == null) {
      return;
    }
    await _database.updateUploadItemStatus(
      id: item.id,
      status: domain.UploadItemStatus.synced,
      progress: 1,
    );

    final rows = await _database.getUploadItems();
    final batchItems = rows
        .where((entry) => entry.batchId == item.batchId)
        .toList();
    final uploadedCount = batchItems
        .where((entry) => entry.status == domain.UploadItemStatus.synced)
        .length;
    final pendingCount = batchItems
        .where((entry) => entry.status != domain.UploadItemStatus.synced)
        .length;
    await _database.updateUploadBatchCounts(
      id: item.batchId,
      uploadedCount: uploadedCount,
      pendingCount: pendingCount,
      status: pendingCount == 0
          ? domain.UploadBatchStatus.completed.name
          : domain.UploadBatchStatus.uploading.name,
    );
  }

  @override
  Future<void> markCurrentUploadingFailed() async {
    final items = await getPendingUploads();
    final uploadingItems = items.where(
      (entry) => entry.status == domain.UploadItemStatus.uploading,
    );
    final item = uploadingItems.isEmpty ? null : uploadingItems.first;
    if (item == null) {
      return;
    }
    await _database.updateUploadItemStatus(
      id: item.id,
      status: domain.UploadItemStatus.failed,
      progress: 0,
      retryCount: item.retryCount + 1,
    );
  }

  @override
  Future<void> markWaitingItemsPending() async {
    final items = await _database.getUploadItems();
    for (final item in items) {
      if (item.status == domain.UploadItemStatus.waiting) {
        await _database.updateUploadItemStatus(
          id: item.id,
          status: domain.UploadItemStatus.pending,
          progress: 0,
        );
      }
    }
  }

  @override
  Future<void> pauseAllUploads() async {
    final items = await _database.getUploadItems();
    for (final item in items) {
      if (item.status == domain.UploadItemStatus.pending ||
          item.status == domain.UploadItemStatus.uploading ||
          item.status == domain.UploadItemStatus.waiting ||
          item.status == domain.UploadItemStatus.failed) {
        await _database.updateUploadItemStatus(
          id: item.id,
          status: domain.UploadItemStatus.paused,
        );
      }
    }
  }

  @override
  Future<void> resumeAllUploads() async {
    final items = await _database.getUploadItems();
    for (final item in items) {
      if (item.status == domain.UploadItemStatus.paused) {
        await _database.updateUploadItemStatus(
          id: item.id,
          status: domain.UploadItemStatus.pending,
          progress: 0,
        );
      }
    }
  }

  @override
  Stream<List<domain.UploadItem>> watchPendingUploads() {
    return _database.watchUploadItems().map((rows) {
      return _sortItems(rows.map(_toDomainItem).toList(growable: false));
    });
  }

  domain.UploadItem _toDomainItem(UploadItemRow row) {
    return domain.UploadItem(
      id: row.id,
      batchId: row.batchId,
      localFilePath: row.localFilePath,
      thumbnailPath: row.thumbnailPath,
      fileName: row.fileName.isNotEmpty
          ? row.fileName
          : path.basename(row.localFilePath),
      fileSize: row.fileSize,
      status: row.status,
      progress: row.progress,
      retryCount: row.retryCount,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  List<domain.UploadItem> _sortItems(List<domain.UploadItem> items) {
    items.sort((a, b) {
      final priorityCompare = _priority(
        a.status,
      ).compareTo(_priority(b.status));
      if (priorityCompare != 0) {
        return priorityCompare;
      }
      final batchCompare = b.batchId.compareTo(a.batchId);
      if (batchCompare != 0) {
        return batchCompare;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return items;
  }

  UploadItemRow? _findById(List<UploadItemRow> items, String id) {
    final matches = items.where((entry) => entry.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  int _priority(domain.UploadItemStatus status) {
    switch (status) {
      case domain.UploadItemStatus.uploading:
        return 0;
      case domain.UploadItemStatus.failed:
        return 1;
      case domain.UploadItemStatus.waiting:
        return 2;
      case domain.UploadItemStatus.pending:
        return 3;
      case domain.UploadItemStatus.paused:
        return 4;
      case domain.UploadItemStatus.synced:
        return 5;
    }
  }
}

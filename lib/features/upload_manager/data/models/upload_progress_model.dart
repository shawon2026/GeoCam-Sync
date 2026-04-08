import '/features/upload_manager/domain/entities/upload_progress.dart';

class UploadProgressModel extends UploadProgress {
  const UploadProgressModel({
    required super.totalItems,
    required super.pendingItems,
    required super.uploadedItems,
    required super.failedItems,
    required super.completion,
  });
}

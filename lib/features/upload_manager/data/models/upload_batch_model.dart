import '/features/upload_manager/domain/entities/upload_batch.dart';

class UploadBatchModel extends UploadBatch {
  const UploadBatchModel({
    required super.id,
    required super.createdAt,
    required super.totalItems,
    required super.uploadedCount,
    required super.pendingCount,
    required super.status,
  });

  factory UploadBatchModel.fromEntity(UploadBatch entity) {
    return UploadBatchModel(
      id: entity.id,
      createdAt: entity.createdAt,
      totalItems: entity.totalItems,
      uploadedCount: entity.uploadedCount,
      pendingCount: entity.pendingCount,
      status: entity.status,
    );
  }
}

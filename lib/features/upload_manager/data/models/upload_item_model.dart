import '/features/upload_manager/domain/entities/upload_item.dart';

class UploadItemModel extends UploadItem {
  const UploadItemModel({
    required super.id,
    required super.batchId,
    required super.localFilePath,
    required super.thumbnailPath,
    required super.fileName,
    required super.fileSize,
    required super.status,
    required super.progress,
    required super.retryCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UploadItemModel.fromEntity(UploadItem entity) {
    return UploadItemModel(
      id: entity.id,
      batchId: entity.batchId,
      localFilePath: entity.localFilePath,
      thumbnailPath: entity.thumbnailPath,
      fileName: entity.fileName,
      fileSize: entity.fileSize,
      status: entity.status,
      progress: entity.progress,
      retryCount: entity.retryCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

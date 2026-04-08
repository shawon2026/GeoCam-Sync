import 'package:equatable/equatable.dart';

enum UploadItemStatus { pending, uploading, waiting, synced, failed, paused }

class UploadItem extends Equatable {
  const UploadItem({
    required this.id,
    required this.batchId,
    required this.localFilePath,
    required this.thumbnailPath,
    required this.fileName,
    required this.fileSize,
    required this.status,
    required this.progress,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String batchId;
  final String localFilePath;
  final String? thumbnailPath;
  final String fileName;
  final int fileSize;
  final UploadItemStatus status;
  final double progress;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  UploadItem copyWith({
    String? id,
    String? batchId,
    String? localFilePath,
    String? thumbnailPath,
    String? fileName,
    int? fileSize,
    UploadItemStatus? status,
    double? progress,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UploadItem(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      localFilePath: localFilePath ?? this.localFilePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    batchId,
    localFilePath,
    thumbnailPath,
    fileName,
    fileSize,
    status,
    progress,
    retryCount,
    createdAt,
    updatedAt,
  ];
}

import 'package:equatable/equatable.dart';

enum UploadBatchStatus { draft, queued, uploading, paused, completed }

class UploadBatch extends Equatable {
  const UploadBatch({
    required this.id,
    required this.createdAt,
    required this.totalItems,
    required this.uploadedCount,
    required this.pendingCount,
    required this.status,
  });

  final String id;
  final DateTime createdAt;
  final int totalItems;
  final int uploadedCount;
  final int pendingCount;
  final UploadBatchStatus status;

  UploadBatch copyWith({
    String? id,
    DateTime? createdAt,
    int? totalItems,
    int? uploadedCount,
    int? pendingCount,
    UploadBatchStatus? status,
  }) {
    return UploadBatch(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      totalItems: totalItems ?? this.totalItems,
      uploadedCount: uploadedCount ?? this.uploadedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    totalItems,
    uploadedCount,
    pendingCount,
    status,
  ];
}

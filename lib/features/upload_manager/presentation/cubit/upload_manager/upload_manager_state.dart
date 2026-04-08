import 'package:equatable/equatable.dart';

import '/features/upload_manager/domain/entities/upload_batch.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';

class UploadManagerState extends Equatable {
  const UploadManagerState({
    this.isLoading = false,
    this.items = const [],
    this.summary = const UploadProgress(
      totalItems: 0,
      pendingItems: 0,
      uploadedItems: 0,
      failedItems: 0,
      completion: 0,
    ),
    this.activeBatch,
    this.isPaused = false,
    this.message,
  });

  final bool isLoading;
  final List<UploadItem> items;
  final UploadProgress summary;
  final UploadBatch? activeBatch;
  final bool isPaused;
  final String? message;

  bool get isEmpty => items.isEmpty;

  UploadManagerState copyWith({
    bool? isLoading,
    List<UploadItem>? items,
    UploadProgress? summary,
    UploadBatch? activeBatch,
    bool? isPaused,
    String? message,
  }) {
    return UploadManagerState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      activeBatch: activeBatch ?? this.activeBatch,
      isPaused: isPaused ?? this.isPaused,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    items,
    summary,
    activeBatch,
    isPaused,
    message,
  ];
}

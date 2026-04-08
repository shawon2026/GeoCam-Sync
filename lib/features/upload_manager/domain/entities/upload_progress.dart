import 'package:equatable/equatable.dart';

class UploadProgress extends Equatable {
  const UploadProgress({
    required this.totalItems,
    required this.pendingItems,
    required this.uploadedItems,
    required this.failedItems,
    required this.completion,
  });

  final int totalItems;
  final int pendingItems;
  final int uploadedItems;
  final int failedItems;
  final double completion;

  @override
  List<Object?> get props => [
    totalItems,
    pendingItems,
    uploadedItems,
    failedItems,
    completion,
  ];
}

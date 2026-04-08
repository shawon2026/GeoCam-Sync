import 'package:equatable/equatable.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/entities/upload_batch.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';

class AddFilesToQueueParams extends Equatable {
  const AddFilesToQueueParams({required this.batchId, required this.captures});

  final String batchId;
  final List<CameraCapture> captures;

  @override
  List<Object?> get props => [batchId, captures];
}

class AddFilesToQueue extends UseCase<UploadBatch, AddFilesToQueueParams> {
  AddFilesToQueue(this.repository);

  final UploadRepository repository;

  @override
  call(AddFilesToQueueParams params) {
    return repository.addFilesToQueue(params.batchId, params.captures);
  }
}

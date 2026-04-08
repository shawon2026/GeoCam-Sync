import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class DeleteCaptureFilesParams {
  const DeleteCaptureFilesParams({
    required this.localPath,
    required this.thumbnailPath,
  });

  final String localPath;
  final String thumbnailPath;
}

class DeleteCaptureFiles extends UseCase<Unit, DeleteCaptureFilesParams> {
  DeleteCaptureFiles(this.repository);

  final CameraRepository repository;

  @override
  call(DeleteCaptureFilesParams params) {
    return repository.deleteCaptureFiles(
      localPath: params.localPath,
      thumbnailPath: params.thumbnailPath,
    );
  }
}

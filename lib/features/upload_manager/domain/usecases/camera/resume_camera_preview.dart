import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class ResumeCameraPreview extends UseCase<Unit, NoParams> {
  ResumeCameraPreview(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.resumePreview();
  }
}

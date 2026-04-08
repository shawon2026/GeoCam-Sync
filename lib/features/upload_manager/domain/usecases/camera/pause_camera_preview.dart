import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class PauseCameraPreview extends UseCase<Unit, NoParams> {
  PauseCameraPreview(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.pausePreview();
  }
}

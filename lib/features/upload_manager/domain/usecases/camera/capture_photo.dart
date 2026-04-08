import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class CapturePhoto extends UseCase<CameraCapture, NoParams> {
  CapturePhoto(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.capturePhoto();
  }
}

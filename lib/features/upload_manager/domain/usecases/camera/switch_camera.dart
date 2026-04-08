import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class SwitchCamera extends UseCase<String, NoParams> {
  SwitchCamera(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.switchCamera();
  }
}

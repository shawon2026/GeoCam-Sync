import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class ToggleFlash extends UseCase<bool, NoParams> {
  ToggleFlash(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.toggleFlash();
  }
}

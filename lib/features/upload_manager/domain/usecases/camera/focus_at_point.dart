import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class FocusAtPoint extends UseCase<FocusPoint, FocusPoint> {
  FocusAtPoint(this.repository);

  final CameraRepository repository;

  @override
  call(FocusPoint params) {
    return repository.focusAtPoint(params);
  }
}

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class SetZoomLevel extends UseCase<double, double> {
  SetZoomLevel(this.repository);

  final CameraRepository repository;

  @override
  call(double params) {
    return repository.setZoomLevel(params);
  }
}

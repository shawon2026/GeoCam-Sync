import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class GetZoomBounds extends UseCase<ZoomBounds, NoParams> {
  GetZoomBounds(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.getZoomBounds();
  }
}

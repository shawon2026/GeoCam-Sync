import 'package:dartz/dartz.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class InitializeCamera extends UseCase<Unit, NoParams> {
  InitializeCamera(this.repository);

  final CameraRepository repository;

  @override
  call(NoParams params) {
    return repository.initializeCamera();
  }
}

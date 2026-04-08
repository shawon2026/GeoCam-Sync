import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/upload_manager/data/datasources/camera_datasource.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  CameraRepositoryImpl({required CameraDataSource dataSource})
    : _dataSource = dataSource;

  final CameraDataSource _dataSource;

  @override
  Future<Either<Failure, CameraCapture>> capturePhoto() async {
    return Right(await _dataSource.capturePhoto());
  }

  @override
  Future<Either<Failure, FocusPoint>> focusAtPoint(FocusPoint point) async {
    return Right(await _dataSource.focusAtPoint(point));
  }

  @override
  Future<Either<Failure, Unit>> initializeCamera() async {
    await _dataSource.initializeCamera();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, double>> setZoomLevel(double zoomLevel) async {
    return Right(await _dataSource.setZoomLevel(zoomLevel));
  }

  @override
  Future<Either<Failure, String>> switchCamera() async {
    return Right(await _dataSource.switchCamera());
  }
}

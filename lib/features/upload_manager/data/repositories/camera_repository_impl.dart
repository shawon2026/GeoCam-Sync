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
    try {
      return Right(await _dataSource.capturePhoto());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FocusPoint>> focusAtPoint(FocusPoint point) async {
    try {
      return Right(await _dataSource.focusAtPoint(point));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeCamera() async {
    try {
      await _dataSource.initializeCamera();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> setZoomLevel(double zoomLevel) async {
    try {
      return Right(await _dataSource.setZoomLevel(zoomLevel));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> switchCamera() async {
    try {
      return Right(await _dataSource.switchCamera());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ZoomBounds>> getZoomBounds() async {
    try {
      return Right(await _dataSource.getZoomBounds());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFlash() async {
    try {
      return Right(await _dataSource.toggleFlash());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> pausePreview() async {
    try {
      await _dataSource.pausePreview();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resumePreview() async {
    try {
      await _dataSource.resumePreview();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCaptureFiles({
    required String localPath,
    required String thumbnailPath,
  }) async {
    try {
      await _dataSource.deleteCaptureFiles(
        localPath: localPath,
        thumbnailPath: thumbnailPath,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

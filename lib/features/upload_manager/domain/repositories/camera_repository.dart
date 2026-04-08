import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';

class FocusPoint extends Equatable {
  const FocusPoint({required this.x, required this.y});

  final double x;
  final double y;

  @override
  List<Object?> get props => [x, y];
}

class ZoomBounds extends Equatable {
  const ZoomBounds({required this.minZoom, required this.maxZoom});

  final double minZoom;
  final double maxZoom;

  @override
  List<Object?> get props => [minZoom, maxZoom];
}

abstract class CameraRepository {
  Future<Either<Failure, Unit>> initializeCamera();

  Future<Either<Failure, CameraCapture>> capturePhoto();

  Future<Either<Failure, double>> setZoomLevel(double zoomLevel);

  Future<Either<Failure, FocusPoint>> focusAtPoint(FocusPoint point);

  Future<Either<Failure, String>> switchCamera();

  Future<Either<Failure, ZoomBounds>> getZoomBounds();

  Future<Either<Failure, bool>> toggleFlash();

  Future<Either<Failure, Unit>> pausePreview();

  Future<Either<Failure, Unit>> resumePreview();

  Future<Either<Failure, Unit>> deleteCaptureFiles({
    required String localPath,
    required String thumbnailPath,
  });
}

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

abstract class CameraRepository {
  Future<Either<Failure, Unit>> initializeCamera();

  Future<Either<Failure, CameraCapture>> capturePhoto();

  Future<Either<Failure, double>> setZoomLevel(double zoomLevel);

  Future<Either<Failure, FocusPoint>> focusAtPoint(FocusPoint point);

  Future<Either<Failure, String>> switchCamera();
}

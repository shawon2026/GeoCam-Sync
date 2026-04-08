import 'package:equatable/equatable.dart';

import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class CameraPreviewState extends Equatable {
  const CameraPreviewState({
    this.isReady = false,
    this.isCapturing = false,
    this.zoomLevel = 1,
    this.cameraLens = 'rear',
    this.focusPoint,
    this.captures = const [],
    this.message,
  });

  final bool isReady;
  final bool isCapturing;
  final double zoomLevel;
  final String cameraLens;
  final FocusPoint? focusPoint;
  final List<CameraCapture> captures;
  final String? message;

  CameraPreviewState copyWith({
    bool? isReady,
    bool? isCapturing,
    double? zoomLevel,
    String? cameraLens,
    FocusPoint? focusPoint,
    List<CameraCapture>? captures,
    String? message,
  }) {
    return CameraPreviewState(
      isReady: isReady ?? this.isReady,
      isCapturing: isCapturing ?? this.isCapturing,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      cameraLens: cameraLens ?? this.cameraLens,
      focusPoint: focusPoint ?? this.focusPoint,
      captures: captures ?? this.captures,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isReady,
    isCapturing,
    zoomLevel,
    cameraLens,
    focusPoint,
    captures,
    message,
  ];
}

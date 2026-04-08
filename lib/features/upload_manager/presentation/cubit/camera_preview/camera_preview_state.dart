import 'package:equatable/equatable.dart';

import '/features/upload_manager/domain/entities/camera_capture.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class CameraPreviewState extends Equatable {
  const CameraPreviewState({
    this.isReady = false,
    this.isCapturing = false,
    this.zoomLevel = 1,
    this.minZoom = 1,
    this.maxZoom = 5,
    this.flashEnabled = false,
    this.cameraLens = 'rear',
    this.focusPoint,
    this.captures = const [],
    this.isGalleryPreviewVisible = false,
    this.galleryIndex = 0,
    this.message,
  });

  final bool isReady;
  final bool isCapturing;
  final double zoomLevel;
  final double minZoom;
  final double maxZoom;
  final bool flashEnabled;
  final String cameraLens;
  final FocusPoint? focusPoint;
  final List<CameraCapture> captures;
  final bool isGalleryPreviewVisible;
  final int galleryIndex;
  final String? message;

  CameraPreviewState copyWith({
    bool? isReady,
    bool? isCapturing,
    double? zoomLevel,
    double? minZoom,
    double? maxZoom,
    bool? flashEnabled,
    String? cameraLens,
    FocusPoint? focusPoint,
    List<CameraCapture>? captures,
    bool? isGalleryPreviewVisible,
    int? galleryIndex,
    String? message,
  }) {
    return CameraPreviewState(
      isReady: isReady ?? this.isReady,
      isCapturing: isCapturing ?? this.isCapturing,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      flashEnabled: flashEnabled ?? this.flashEnabled,
      cameraLens: cameraLens ?? this.cameraLens,
      focusPoint: focusPoint ?? this.focusPoint,
      captures: captures ?? this.captures,
      isGalleryPreviewVisible:
          isGalleryPreviewVisible ?? this.isGalleryPreviewVisible,
      galleryIndex: galleryIndex ?? this.galleryIndex,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isReady,
    isCapturing,
    zoomLevel,
    minZoom,
    maxZoom,
    flashEnabled,
    cameraLens,
    focusPoint,
    captures,
    isGalleryPreviewVisible,
    galleryIndex,
    message,
  ];
}

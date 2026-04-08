import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '/core/services/thumbnail_service.dart';
import '/core/utils/camera_zoom_utils.dart';
import '/core/utils/file_utils.dart';
import '/features/upload_manager/data/models/camera_capture_model.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

abstract class CameraDataSource {
  CameraController? get controller;

  Future<void> initializeCamera();

  Future<CameraCaptureModel> capturePhoto();

  Future<double> setZoomLevel(double zoomLevel);

  Future<FocusPoint> focusAtPoint(FocusPoint point);

  Future<String> switchCamera();

  Future<ZoomBounds> getZoomBounds();

  Future<bool> toggleFlash();

  Future<void> pausePreview();

  Future<void> resumePreview();

  Future<void> deleteCaptureFiles({
    required String localPath,
    required String thumbnailPath,
  });
}

class CameraDataSourceImpl implements CameraDataSource {
  CameraDataSourceImpl({required ThumbnailService thumbnailService})
    : _thumbnailService = thumbnailService;

  final ThumbnailService _thumbnailService;
  List<CameraDescription> _availableCameras = const [];
  CameraController? _controller;
  double _zoomLevel = 1;
  double _minZoom = 1;
  double _maxZoom = 5;
  bool _flashEnabled = false;
  String _cameraLens = 'rear';

  @override
  CameraController? get controller => _controller;

  @override
  Future<CameraCaptureModel> capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw CameraException('uninitialized', 'Camera is not ready');
    }
    final tempDir = await getTemporaryDirectory();
    final filePath = path.join(
      tempDir.path,
      'capture_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    final file = await controller.takePicture();
    await File(file.path).copy(filePath);
    final originalFile = File(file.path);
    if (await originalFile.exists()) {
      await originalFile.delete();
    }
    final thumbnailPath = await _thumbnailService.buildThumbnailPath(filePath);
    final savedFile = File(filePath);
    return CameraCaptureModel(
      localPath: savedFile.path,
      thumbnailPath: thumbnailPath,
      fileName: FileUtils.fileNameFromPath(savedFile.path),
      fileSize: await savedFile.length(),
      capturedAt: DateTime.now(),
    );
  }

  @override
  Future<FocusPoint> focusAtPoint(FocusPoint point) async {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      await controller.setFocusPoint(ui.Offset(point.x, point.y));
    }
    return point;
  }

  @override
  Future<void> initializeCamera() async {
    _availableCameras = await availableCameras();
    if (_availableCameras.isEmpty) {
      throw CameraException('no-camera', 'No camera available');
    }
    await _initializeController(_pickCamera(_cameraLens));
  }

  @override
  Future<double> setZoomLevel(double zoomLevel) async {
    final nextZoom = CameraZoomUtils.clamp(
      zoomLevel,
      min: _minZoom,
      max: _maxZoom,
    );
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      await controller.setZoomLevel(nextZoom);
    }
    _zoomLevel = nextZoom;
    return _zoomLevel;
  }

  @override
  Future<String> switchCamera() async {
    if (_availableCameras.isEmpty) {
      await initializeCamera();
      return _cameraLens;
    }
    _cameraLens = _cameraLens == 'rear' ? 'front' : 'rear';
    await _initializeController(_pickCamera(_cameraLens));
    return _cameraLens;
  }

  @override
  Future<ZoomBounds> getZoomBounds() async {
    return ZoomBounds(minZoom: _minZoom, maxZoom: _maxZoom);
  }

  @override
  Future<bool> toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw CameraException('uninitialized', 'Camera is not ready');
    }

    final nextEnabled = !_flashEnabled;
    await controller.setFlashMode(
      nextEnabled ? FlashMode.torch : FlashMode.off,
    );
    _flashEnabled = nextEnabled;
    return _flashEnabled;
  }

  @override
  Future<void> pausePreview() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await controller.pausePreview();
  }

  @override
  Future<void> resumePreview() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await controller.resumePreview();
  }

  @override
  Future<void> deleteCaptureFiles({
    required String localPath,
    required String thumbnailPath,
  }) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
    final thumbnail = File(thumbnailPath);
    if (await thumbnail.exists()) {
      await thumbnail.delete();
    }
  }

  CameraDescription _pickCamera(String desiredLens) {
    if (desiredLens == 'front') {
      final front = _availableCameras.where(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      if (front.isNotEmpty) {
        return front.first;
      }
    }
    final back = _availableCameras.where(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    if (back.isNotEmpty) {
      return back.first;
    }
    return _availableCameras.first;
  }

  Future<void> _initializeController(CameraDescription camera) async {
    await _controller?.dispose();
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await controller.initialize();
    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    _zoomLevel = _zoomLevel.clamp(_minZoom, _maxZoom);
    await controller.setZoomLevel(_zoomLevel);
    await controller.setFlashMode(FlashMode.off);
    _flashEnabled = false;
    _controller = controller;
    _cameraLens = camera.lensDirection == CameraLensDirection.front
        ? 'front'
        : 'rear';
  }
}

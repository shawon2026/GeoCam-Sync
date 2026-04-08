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
}

class CameraDataSourceImpl implements CameraDataSource {
  CameraDataSourceImpl({required ThumbnailService thumbnailService})
    : _thumbnailService = thumbnailService;

  final ThumbnailService _thumbnailService;
  List<CameraDescription> _availableCameras = const [];
  CameraController? _controller;
  double _zoomLevel = 1;
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
    final nextZoom = CameraZoomUtils.clamp(zoomLevel);
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
    final minZoom = await controller.getMinZoomLevel();
    final maxZoom = await controller.getMaxZoomLevel();
    _zoomLevel = _zoomLevel.clamp(minZoom, maxZoom);
    await controller.setZoomLevel(_zoomLevel);
    _controller = controller;
    _cameraLens = camera.lensDirection == CameraLensDirection.front
        ? 'front'
        : 'rear';
  }
}

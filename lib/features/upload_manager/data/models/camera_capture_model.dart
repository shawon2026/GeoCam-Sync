import '/features/upload_manager/domain/entities/camera_capture.dart';

class CameraCaptureModel extends CameraCapture {
  const CameraCaptureModel({
    required super.localPath,
    required super.thumbnailPath,
    required super.fileName,
    required super.fileSize,
    required super.capturedAt,
  });
}

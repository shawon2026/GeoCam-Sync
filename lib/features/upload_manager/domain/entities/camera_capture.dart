import 'package:equatable/equatable.dart';

class CameraCapture extends Equatable {
  const CameraCapture({
    required this.localPath,
    required this.thumbnailPath,
    required this.fileName,
    required this.fileSize,
    required this.capturedAt,
  });

  final String localPath;
  final String thumbnailPath;
  final String fileName;
  final int fileSize;
  final DateTime capturedAt;

  @override
  List<Object?> get props => [
    localPath,
    thumbnailPath,
    fileName,
    fileSize,
    capturedAt,
  ];
}

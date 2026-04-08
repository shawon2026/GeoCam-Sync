class UploadConstants {
  static const int maxConcurrentUploads = 1;
  static const int maxRetryCount = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const double defaultZoom = 1;
}

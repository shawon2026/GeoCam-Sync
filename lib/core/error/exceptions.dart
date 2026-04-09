/// Base exception class for the application
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() =>
      statusCode != null ? message : '$message (Status Code: $statusCode)';
}

/// Cache exception for local storage errors
class CacheException extends AppException {
  CacheException({required super.message, super.statusCode});
}

class LocationPermissionException extends AppException {
  LocationPermissionException({required super.message, super.statusCode});
}

class LocationServiceException extends AppException {
  LocationServiceException({required super.message, super.statusCode});
}

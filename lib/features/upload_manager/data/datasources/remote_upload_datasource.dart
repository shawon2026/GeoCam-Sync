import '/features/upload_manager/domain/entities/upload_item.dart';

abstract class RemoteUploadDataSource {
  Future<void> upload(UploadItem item);
}

class DummyUploadException implements Exception {
  const DummyUploadException({
    required this.message,
    this.isNetworkIssue = false,
  });

  final String message;
  final bool isNetworkIssue;

  @override
  String toString() => 'DummyUploadException($message)';
}

class RemoteUploadDataSourceImpl implements RemoteUploadDataSource {
  @override
  Future<void> upload(UploadItem item) async {
    // Dummy upload simulation: no real URL call, just network delay.
    final delayMs = 2000 + (item.id.hashCode.abs() % 1000);
    await Future<void>.delayed(Duration(milliseconds: delayMs));
  }
}

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
  final Map<String, int> _attemptCounter = <String, int>{};

  @override
  Future<void> upload(UploadItem item) async {
    final attempt = (_attemptCounter[item.id] ?? 0) + 1;
    _attemptCounter[item.id] = attempt;

    final delayMs = 2000 + (item.id.hashCode.abs() % 1000);
    await Future<void>.delayed(Duration(milliseconds: delayMs));

    final bucket = item.id.hashCode.abs() % 4;
    if (bucket == 0 && attempt == 1) {
      throw const DummyUploadException(
        message: 'Simulated unstable network on first attempt',
        isNetworkIssue: true,
      );
    }
    if (bucket == 1 && attempt <= 2) {
      throw const DummyUploadException(
        message: 'Simulated transient server error',
      );
    }
  }
}

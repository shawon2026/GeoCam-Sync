import '/features/upload_manager/domain/entities/upload_item.dart';

abstract class RemoteUploadDataSource {
  Future<void> upload(UploadItem item);
}

class RemoteUploadDataSourceImpl implements RemoteUploadDataSource {
  @override
  Future<void> upload(UploadItem item) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}

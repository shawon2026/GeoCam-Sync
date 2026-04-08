import 'package:drift/drift.dart';

import '/features/upload_manager/domain/entities/upload_item.dart';

class UploadStatusConverter extends TypeConverter<UploadItemStatus, String> {
  const UploadStatusConverter();

  @override
  UploadItemStatus fromSql(String fromDb) {
    return UploadItemStatus.values.firstWhere(
      (value) => value.name == fromDb,
      orElse: () => UploadItemStatus.pending,
    );
  }

  @override
  String toSql(UploadItemStatus value) {
    return value.name;
  }
}

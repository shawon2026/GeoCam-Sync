import 'package:drift/drift.dart';

import '/db/converters/upload_status_converter.dart';

@DataClassName('UploadItemRow')
class UploadItems extends Table {
  TextColumn get id => text()();

  TextColumn get batchId => text()();

  TextColumn get localFilePath => text()();

  TextColumn get thumbnailPath => text().nullable()();

  TextColumn get fileName => text()();

  IntColumn get fileSize => integer()();

  TextColumn get status => text().map(const UploadStatusConverter())();

  RealColumn get progress => real().withDefault(const Constant(0))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

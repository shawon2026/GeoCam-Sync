import 'package:drift/drift.dart';

@DataClassName('UploadBatchRow')
class UploadBatches extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get totalItems => integer()();

  IntColumn get uploadedCount => integer().withDefault(const Constant(0))();

  IntColumn get pendingCount => integer().withDefault(const Constant(0))();

  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

import 'package:drift/drift.dart';

class OfficeConfigs extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();

  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

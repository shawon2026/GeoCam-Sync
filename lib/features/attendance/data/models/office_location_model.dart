import 'package:drift/drift.dart' as drift;
import '/db/app_database.dart';
import '/features/attendance/domain/entities/office_location.dart';

class OfficeLocationModel extends OfficeLocation {
  const OfficeLocationModel({
    required super.latitude,
    required super.longitude,
    required super.updatedAt,
  });

  factory OfficeLocationModel.fromDb(OfficeConfig config) {
    return OfficeLocationModel(
      latitude: config.latitude,
      longitude: config.longitude,
      updatedAt: DateTime.parse(config.updatedAt),
    );
  }

  OfficeConfigsCompanion toCompanion() {
    return OfficeConfigsCompanion(
      id: const drift.Value(1),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      updatedAt: drift.Value(updatedAt.toIso8601String()),
    );
  }
}

import 'package:dartz/dartz.dart';
import '/core/error/exception_handler.dart';
import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '/core/utils/date_time_helper.dart';
import '/features/attendance/data/datasources/attendance_local_datasource.dart';
import '/features/attendance/data/datasources/location_datasource.dart';
import '/features/attendance/data/models/attendance_record_model.dart';
import '/features/attendance/data/models/office_location_model.dart';
import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/entities/office_location.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl({
    required AttendanceLocalDataSource localDataSource,
    required LocationDataSource locationDataSource,
  }) : _localDataSource = localDataSource,
       _locationDataSource = locationDataSource;

  final AttendanceLocalDataSource _localDataSource;
  final LocationDataSource _locationDataSource;

  @override
  Future<Either<Failure, OfficeLocation?>> getOfficeLocation() {
    return handleException(() async {
      return _localDataSource.getOfficeLocation();
    });
  }

  @override
  Future<Either<Failure, OfficeLocation>> saveOfficeLocationFromCurrent() {
    return handleException(() async {
      final location = await _locationDataSource.getCurrentLocation();
      if (location.latitude == null || location.longitude == null) {
        throw LocationServiceException(
          message: 'Current location is unavailable',
        );
      }

      final officeModel = OfficeLocationModel(
        latitude: location.latitude!,
        longitude: location.longitude!,
        updatedAt: DateTimeHelper.now(),
      );

      await _localDataSource.saveOfficeLocation(officeModel);
      return officeModel;
    });
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity?>> getTodayAttendance() {
    return handleException(() async {
      return _localDataSource.getTodayAttendance();
    });
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity>> markAttendance({
    required bool isLate,
    required double distanceMeters,
  }) {
    return handleException(() async {
      final location = await _locationDataSource.getCurrentLocation();
      if (location.latitude == null || location.longitude == null) {
        throw LocationServiceException(
          message: 'Current location is unavailable',
        );
      }

      final model = AttendanceRecordModel(
        attendanceDate: DateTimeHelper.toDateKey(DateTimeHelper.now()),
        markedAt: DateTimeHelper.now(),
        status: isLate
            ? AttendanceMarkStatus.late
            : AttendanceMarkStatus.present,
        latitude: location.latitude!,
        longitude: location.longitude!,
        distanceMeters: distanceMeters,
      );

      await _localDataSource.saveAttendance(model);
      return model;
    });
  }

  @override
  Future<Either<Failure, double>> getDistanceToOffice() {
    return handleException(() async {
      final office = await _localDataSource.getOfficeLocation();
      if (office == null) {
        throw CacheException(message: 'Office location is not set');
      }
      return _locationDataSource.distanceToOffice(office);
    });
  }

  @override
  Stream<double> watchDistanceToOffice() async* {
    final office = await _localDataSource.getOfficeLocation();
    if (office == null) {
      yield double.infinity;
      return;
    }
    yield* _locationDataSource.watchDistanceToOffice(office);
  }

  @override
  Stream<List<AttendanceRecordEntity>> watchAttendanceHistory() {
    return _localDataSource.watchAttendanceHistory();
  }

  @override
  Future<Either<Failure, bool>> isPermissionGranted() {
    return handleException(() async {
      return _locationDataSource.isPermissionGranted();
    });
  }

  @override
  Future<Either<Failure, bool>> ensurePermission() {
    return handleException(() async {
      final granted = await _locationDataSource.ensurePermission();
      if (!granted) {
        throw LocationPermissionException(
          message: 'Location permission is required',
        );
      }
      return granted;
    });
  }

  @override
  Future<Either<Failure, bool>> isPrecisePermissionGranted() {
    return handleException(() async {
      final isPrecise = await _locationDataSource.isPrecisePermissionGranted();
      if (!isPrecise) {
        throw LocationPermissionException(
          message: 'Precise location permission is required',
        );
      }
      return true;
    });
  }

  @override
  Future<Either<Failure, bool>> isServiceEnabled() {
    return handleException(() async {
      return _locationDataSource.isServiceEnabled();
    });
  }

  @override
  Future<Either<Failure, bool>> ensureServiceEnabled() {
    return handleException(() async {
      final enabled = await _locationDataSource.ensureServiceEnabled();
      if (!enabled) {
        throw LocationServiceException(
          message: 'Location service must be enabled',
        );
      }
      return enabled;
    });
  }

  @override
  Future<Either<Failure, void>> openAppSettings() {
    return handleException(() async {
      await _locationDataSource.openAppSettings();
    });
  }

  @override
  Future<Either<Failure, void>> openLocationSettings() {
    return handleException(() async {
      await _locationDataSource.openLocationSettings();
    });
  }
}

import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/entities/office_location.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, OfficeLocation?>> getOfficeLocation();

  Future<Either<Failure, OfficeLocation>> saveOfficeLocationFromCurrent();

  Future<Either<Failure, AttendanceRecordEntity?>> getTodayAttendance();

  Future<Either<Failure, AttendanceRecordEntity>> markAttendance({
    required bool isLate,
    required double distanceMeters,
  });

  Future<Either<Failure, double>> getDistanceToOffice();

  Stream<double> watchDistanceToOffice();

  Stream<List<AttendanceRecordEntity>> watchAttendanceHistory();

  Future<Either<Failure, bool>> isPermissionGranted();

  Future<Either<Failure, bool>> ensurePermission();

  Future<Either<Failure, bool>> isPrecisePermissionGranted();

  Future<Either<Failure, bool>> isServiceEnabled();

  Future<Either<Failure, bool>> ensureServiceEnabled();

  Future<Either<Failure, void>> openAppSettings();

  Future<Either<Failure, void>> openLocationSettings();
}

import 'dart:async';
import 'package:location/location.dart';
import '/core/constants/attendance_constants.dart';
import '/core/services/app_settings_service.dart';
import '/core/utils/distance_helper.dart';
import '/features/attendance/domain/entities/office_location.dart';

abstract class LocationDataSource {
  Future<bool> isPermissionGranted();

  Future<bool> ensurePermission();

  Future<bool> isPrecisePermissionGranted();

  Future<bool> isServiceEnabled();

  Future<bool> ensureServiceEnabled();

  Future<void> openAppSettings();

  Future<void> openLocationSettings();

  Future<LocationData> getCurrentLocation();

  Stream<LocationData> watchLocation();

  Future<double> distanceToOffice(OfficeLocation officeLocation);

  Stream<double> watchDistanceToOffice(OfficeLocation officeLocation);
}

class LocationDataSourceImpl implements LocationDataSource {
  LocationDataSourceImpl({
    required Location location,
    required AppSettingsService appSettingsService,
  }) : _location = location,
       _appSettingsService = appSettingsService;

  final Location _location;
  final AppSettingsService _appSettingsService;

  @override
  Future<bool> isPermissionGranted() async {
    final status = await _location.hasPermission();
    return status == PermissionStatus.granted;
  }

  @override
  Future<bool> ensurePermission() async {
    final status = await _location.requestPermission();
    return status == PermissionStatus.granted;
  }

  @override
  Future<bool> isPrecisePermissionGranted() async {
    final status = await _location.hasPermission();
    if (status != PermissionStatus.granted) {
      return false;
    }

    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      return true;
    }

    await _location.changeSettings(accuracy: LocationAccuracy.high);
    final data = await _location.getLocation();
    final accuracy = data.accuracy;
    if (accuracy == null) {
      return false;
    }

    return accuracy <= AttendanceConstants.preciseLocationMaxAccuracyMeters;
  }

  @override
  Future<bool> isServiceEnabled() async {
    return _location.serviceEnabled();
  }

  @override
  Future<bool> ensureServiceEnabled() async {
    return _location.requestService();
  }

  @override
  Future<void> openAppSettings() {
    return _appSettingsService.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() {
    return _appSettingsService.openLocationSettings();
  }

  @override
  Future<LocationData> getCurrentLocation() {
    return _location.getLocation();
  }

  @override
  Stream<LocationData> watchLocation() async* {
    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 1,
    );
    yield* _location.onLocationChanged;
  }

  @override
  Future<double> distanceToOffice(OfficeLocation officeLocation) async {
    final current = await getCurrentLocation();
    final lat = current.latitude;
    final lng = current.longitude;
    if (lat == null || lng == null) return double.infinity;

    return DistanceHelper.calculateMeters(
      fromLatitude: lat,
      fromLongitude: lng,
      toLatitude: officeLocation.latitude,
      toLongitude: officeLocation.longitude,
    );
  }

  @override
  Stream<double> watchDistanceToOffice(OfficeLocation officeLocation) {
    return watchLocation().map((current) {
      final lat = current.latitude;
      final lng = current.longitude;
      if (lat == null || lng == null) return double.infinity;

      return DistanceHelper.calculateMeters(
        fromLatitude: lat,
        fromLongitude: lng,
        toLatitude: officeLocation.latitude,
        toLongitude: officeLocation.longitude,
      );
    });
  }
}

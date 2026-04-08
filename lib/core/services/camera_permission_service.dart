import 'package:permission_handler/permission_handler.dart';

import '/core/services/app_settings_service.dart';

class CameraPermissionService {
  const CameraPermissionService({
    required AppSettingsService appSettingsService,
  }) : _appSettingsService = appSettingsService;

  final AppSettingsService _appSettingsService;

  Future<bool> isGranted() async {
    return Permission.camera.isGranted;
  }

  Future<PermissionStatus> request() {
    return Permission.camera.request();
  }

  Future<void> openSettings() {
    return _appSettingsService.openAppSettings();
  }
}

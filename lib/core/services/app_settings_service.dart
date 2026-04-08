import 'package:app_settings/app_settings.dart';

class AppSettingsService {
  const AppSettingsService();

  Future<void> openAppSettings() async {
    await AppSettings.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }
}

enum AppConstants {
  bearer('Bearer'),
  applicationJson('application/json'),
  android('android'),
  ios('ios'),
  en('en'),
  bn('bn'),
  token('token'),
  language('language'),
  yyyyMmDd('yyyy-MM-dd'),
  yyyyMm('yyyy-MM'),
  deviceId('device-id'),
  deviceOs('device-os'),
  appVersion('app-version'),
  buildNumber('build-number'),
  isDarkMode('is-dark-mode'),
  deviceName('device-name'),
  deviceModel('device-model'),
  deviceOsVersion('device-os-version');

  final String key;
  const AppConstants(this.key);
}

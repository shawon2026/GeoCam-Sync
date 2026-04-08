import 'package:flutter/material.dart';
import '/core/utils/preferences_helper.dart';

class LocaleManager {
  LocaleManager._();

  static final LocaleManager instance = LocaleManager._();

  final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(
    const Locale('en', 'US'),
  );

  Locale get currentLocale => localeNotifier.value;

  Future<void> loadSavedLocale() async {
    final languageCode = PrefHelper.instance.getLanguage();
    localeNotifier.value = languageCode == 1
        ? const Locale('en', 'US')
        : const Locale('bn', 'BD');
  }

  Future<void> toggleLanguage() async {
    final isEnglish = localeNotifier.value.languageCode == 'en';
    if (isEnglish) {
      await PrefHelper.instance.setLanguage(2);
      localeNotifier.value = const Locale('bn', 'BD');
    } else {
      await PrefHelper.instance.setLanguage(1);
      localeNotifier.value = const Locale('en', 'US');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  LocaleManager._();

  static final LocaleManager instance = LocaleManager._();
  static const _languageKey = 'language';

  final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(
    const Locale('en', 'US'),
  );

  Locale get currentLocale => localeNotifier.value;

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getInt(_languageKey) ?? 1;
    localeNotifier.value = languageCode == 1
        ? const Locale('en', 'US')
        : const Locale('bn', 'BD');
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = localeNotifier.value.languageCode == 'en';
    if (isEnglish) {
      await prefs.setInt(_languageKey, 2);
      localeNotifier.value = const Locale('bn', 'BD');
    } else {
      await prefs.setInt(_languageKey, 1);
      localeNotifier.value = const Locale('en', 'US');
    }
  }
}

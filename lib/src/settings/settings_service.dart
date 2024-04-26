import 'package:flutter/material.dart';

import 'preferences.dart';

class SettingsService {
  //settings for theme mode
  Future<ThemeMode> themeMode() async => Preferences.getThemeMode();

  Future<void> updateThemeMode(ThemeMode theme) async {
    await Preferences.setThemeMode(theme);
  }

  //setting for locale/language
  Future<Locale> localeMode() async => Preferences.getLocale();

  Future<void> updateLocaleMode(Locale locale) async {
    await Preferences.setLocale(locale);
  }

  //setting for onboarding
  Future<bool> showOnboarding() async => Preferences.getShowOnboarding();

  Future<void> updateShowOnboarding(bool show) async {
    await Preferences.setShowOnboarding(show);
  }
}

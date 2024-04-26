import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;

  late Locale _localeMode;

  late bool _showOnboarding;

  ThemeMode get themeMode => _themeMode;

  Locale get localeMode => _localeMode;

  bool get showOnboarding => _showOnboarding;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _localeMode = await _settingsService.localeMode();
    _showOnboarding = await _settingsService.showOnboarding();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocaleMode(Locale? newLocaleMode) async {
    if (newLocaleMode == null) return;
    if (newLocaleMode == _localeMode) return;
    _localeMode = newLocaleMode;
    notifyListeners();
    await _settingsService.updateLocaleMode(newLocaleMode);
  }

  Future<void> updateShowOnboarding(bool show) async {
    if (show == _showOnboarding) return;
    _showOnboarding = show;
    notifyListeners();
    await _settingsService.updateShowOnboarding(show);
  }
}

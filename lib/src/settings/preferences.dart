import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const onboarding = 'onboarding';
  static const locale = 'locale';
  static const theme = 'theme';
  static const listRecentContacts = 'recent';
  static const cguUrl =
      'https://firebasestorage.googleapis.com/v0/b/get-pansia-dev.appspot.com/o/files%2FCGU.pdf?alt=media&token=54c014db-6179-4e55-9a4c-a76d352e65fb';
  static const policyUrl =
      'https://firebasestorage.googleapis.com/v0/b/get-pansia-dev.appspot.com/o/files%2FPC.pdf?alt=media&token=f45b1428-dab3-4e49-ba25-1a6cd5718c84';

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> getShowOnboarding() async {
    final SharedPreferences prefs = await _prefs;
    final showOnboarding = prefs.getBool(onboarding);
    return showOnboarding ?? true;
  }

  static Future<void> setShowOnboarding(bool show) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(onboarding, show);
  }

  static Future<void> setLocale(Locale loc) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(locale, loc.languageCode);
  }

  static Future<Locale> getLocale() async {
    final SharedPreferences prefs = await _prefs;
    final loc = prefs.getString(locale);
    return loc == null ? const Locale('fr', '') : Locale(loc, '');
  }

  static Future<void> setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(theme, themeMode.name);
  }

  static Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    final themeMode = prefs.getString(theme);
    switch (themeMode) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<List<String>> getListRecentContacts() async {
    final SharedPreferences prefs = await _prefs;
    final list = prefs.getStringList(listRecentContacts);
    return list ?? [];
  }

  static Future<void> setListRecentContacts(List<String> listRecent) async {
    if (listRecent.length > 5) {
      listRecent = listRecent.sublist(0, 4);
    }
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(listRecentContacts, listRecent);
  }
}

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../tools.dart';

class RemoteConfigNotifier with ChangeNotifier {
  final String androidUrl =
      'https://play.google.com/store/apps/details?id=package_name';
  final String iOSUrl = 'https://apps.apple.com/us/app/praticpower/bundle_id';
  String? _currentVersion;
  String? _remoteVersion;
  bool? _remoteBreak;
  bool get isNotReady =>
      _remoteConfig == null || requireUpdate == null || _remoteBreak == null;
  bool get isReady =>
      _remoteConfig != null && requireUpdate != null && _remoteBreak != null;
  bool get requireBreak => _remoteBreak == true;
  bool? requireUpdate;
  FirebaseRemoteConfig? _remoteConfig;

  final Duration fetchTimeout = const Duration(seconds: 2);
  final Duration minimumFetchInterval = const Duration(minutes: 30);

  Future<void> init(BuildContext context) async {
    var appLocalizations = AppLocalizations.of(context)!;
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await _remoteConfig!.setDefaults(
      <String, dynamic>{
        breakName: false,
        versionName: '1.0.0',
      },
    );
    RemoteConfigValue(null, ValueSource.valueStatic);
    await _remoteConfig!.fetchAndActivate();
    _remoteBreak = _remoteConfig!.getBool(breakName);
    _remoteVersion = _remoteConfig!.getString(versionName);
    if (_remoteBreak == true) {
      if (context.mounted) {
        Dialogs.of(context).showUpdateVersionDialog(
          title: appLocalizations.dialog_title_maintenance,
          subtitle: appLocalizations.dialog_content_maintenance,
          label: appLocalizations.close,
          onContionue: SystemNavigator.pop,
        );
      }
    } else {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      finalize();
      if (requireUpdate == true) {
        if (context.mounted) {
          Dialogs.of(context).showUpdateVersionDialog(
            title: appLocalizations.dialog_title_update,
            subtitle: appLocalizations.dialog_content_update,
            label: appLocalizations.update,
            onContionue: () => launchUrl(
              Uri.parse(
                Platform.isIOS ? iOSUrl : androidUrl,
              ),
            ),
          );
        }
      }
    }
    notifyListeners();
  }

  void finalize() {
    assert(_remoteVersion != null);
    assert(_currentVersion != null);
    List<int> remoteVersions =
        _remoteVersion!.split('.').map((e) => int.parse(e)).toList();
    List<int> currentVersions =
        _currentVersion!.split('.').map((e) => int.parse(e)).toList();
    assert(remoteVersions.length == currentVersions.length);
    requireUpdate = remoteVersions[0] > currentVersions[0] ||
        remoteVersions[1] > currentVersions[1] ||
        remoteVersions[2] > currentVersions[2];
    requireUpdate ??= false;
  }

  String get versionName {
    if (Platform.isAndroid) {
      return 'androidVersion';
    } else {
      return 'iOSVersion';
    }
  }

  String get breakName {
    if (Platform.isAndroid) {
      return 'androidBreak';
    } else {
      return 'iOSBreak';
    }
  }
}

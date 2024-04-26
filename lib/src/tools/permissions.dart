import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialogs.dart';

class Permissions {
  final BuildContext context;

  Permissions(this.context);

  static Permissions of(BuildContext context) {
    assert(context.mounted);
    return Permissions(context);
  }

  ///return `true` if device location is enabled, else return `false`.
  static Future<bool> getLocationEnabled() async {
    return await Permission.locationWhenInUse.serviceStatus.isEnabled;
  }

  ///Check if app have permission to access photo library, if yes return `false`,
  ///else show a dialog with title `Permission required` then return `true`
  Future<bool> showPhotoLibraryPermission() async {
    return await getPhotoLibraryPermission().then((hasPermission) {
      if (!hasPermission) {
        Dialogs.of(context).showPermissionDialog(
          title: AppLocalizations.of(context)!.dialog_title_permission_required,
          subtitle: Platform.isIOS
              ? AppLocalizations.of(context)!
                  .dialog_content_permission_photos_ios
              : AppLocalizations.of(context)!
                  .dialog_content_permission_photos_android,
          appSettingsType: AppSettingsType.settings,
        );
      }
      return !hasPermission;
    });
  }

  ///Check if app have permission to access device location, if yes return `false`,
  ///else show a dialog with title `Permission required` then return `true`
  Future<bool> showLocationPermission() async {
    return await getLocationPermission().then((hasPermission) {
      if (!hasPermission) {
        Dialogs.of(context).showPermissionDialog(
          title: AppLocalizations.of(context)!.dialog_title_permission_required,
          subtitle: Platform.isIOS
              ? AppLocalizations.of(context)!
                  .dialog_content_permission_location_ios
              : AppLocalizations.of(context)!
                  .dialog_content_permission_location_android,
          appSettingsType: AppSettingsType.settings,
        );
      }
      return !hasPermission;
    });
  }

  ///Check if device location is enabled, if yes return `false`,
  ///else show a dialog with title `Permission required` then return `true`
  Future<bool> showLocationEnabled() async {
    return await getLocationEnabled().then((hasPermission) {
      if (!hasPermission) {
        Dialogs.of(context).showPermissionDialog(
          title: AppLocalizations.of(context)!.dialog_title_permission_required,
          subtitle: Platform.isIOS
              ? AppLocalizations.of(context)!.dialog_content_enable_location_ios
              : AppLocalizations.of(context)!
                  .dialog_content_enable_location_android,
          appSettingsType: Platform.isAndroid ? AppSettingsType.location : null,
        );
      }
      return !hasPermission;
    });
  }

  ///Check if app have permission to access device camera, if yes return `false`,
  ///else show a dialog with title `Permission required` then return `true`
  Future<bool> showCameraPermission() async {
    return await getCameraPermission().then((hasPermission) {
      if (!hasPermission) {
        Dialogs.of(context).showPermissionDialog(
          title: AppLocalizations.of(context)!.dialog_title_permission_required,
          subtitle: Platform.isIOS
              ? AppLocalizations.of(context)!
                  .dialog_content_permission_camera_ios
              : AppLocalizations.of(context)!
                  .dialog_content_permission_camera_android,
          appSettingsType: AppSettingsType.settings,
        );
      }
      return !hasPermission;
    });
  }

  ///Check if app have permission to access device microphone, if yes return `false`,
  ///else show a dialog with title `Permission required` then return `true`
  Future<bool> showMicrophonePermission() async {
    return await getMicrophonePermission().then((hasPermission) {
      if (!hasPermission) {
        Dialogs.of(context).showPermissionDialog(
          title: AppLocalizations.of(context)!.dialog_title_permission_required,
          subtitle: Platform.isIOS
              ? AppLocalizations.of(context)!
                  .dialog_content_permission_microphone_ios
              : AppLocalizations.of(context)!
                  .dialog_content_permission_microphone_android,
          appSettingsType: AppSettingsType.settings,
        );
      }
      return !hasPermission;
    });
  }

  ///Check if app have permission to access device camera, if permission is
  ///`isGranted` return `true`, else if permission is `isPermanentlyDenied` open
  ///app settings screen and return `false`, else if permission is not
  ///`isGranted` request to use camera, if request is denied return `false`,
  ///else if granted return `true`.
  Future<bool> getCameraPermission() async {
    late PermissionStatus serviceStatus;
    serviceStatus = await Permission.camera.status;
    if (serviceStatus.isPermanentlyDenied) {
      return false;
    }
    if (!serviceStatus.isGranted) {
      await Permission.camera.request();
      serviceStatus = await Permission.camera.status;
      if (!serviceStatus.isGranted) {
        return false;
      }
    }
    return true;
  }

  ///Check if app have permission to access device microphone, if permission is
  ///`isGranted` return `true`, else if permission is `isPermanentlyDenied` open
  ///app settings screen and return `false`, else if permission is not
  ///`isGranted` request to use microphone, if request is denied return `false`,
  ///else if granted return `true`.
  Future<bool> getMicrophonePermission() async {
    late PermissionStatus serviceStatus;
    serviceStatus = await Permission.microphone.status;
    if (serviceStatus.isPermanentlyDenied) {
      return false;
    }
    if (!serviceStatus.isGranted) {
      await Permission.microphone.request();
      serviceStatus = await Permission.microphone.status;
      if (!serviceStatus.isGranted) {
        return false;
      }
    }
    return true;
  }

  ///Check if app have permission to access device photo lobrary, if permission is
  ///`isGranted` return `true`, else if permission is `isPermanentlyDenied` open
  ///app settings screen and return `false`, else if permission is not
  ///`isGranted` request to use photo lobrary, if request is denied return `false`,
  ///else if granted return `true`.
  Future<bool> getPhotoLibraryPermission() async {
    late Permission permission;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }
    late PermissionStatus serviceStatus;
    serviceStatus = await permission.status;
    if (serviceStatus.isPermanentlyDenied) {
      // openAppSettings();
      return false;
    }
    if (!serviceStatus.isGranted && !serviceStatus.isLimited) {
      await permission.request();
      serviceStatus = await permission.status;
      if (!serviceStatus.isGranted && !serviceStatus.isLimited) {
        return false;
      }
    }
    return true;
  }

  ///Check if app have permission to access device location, if permission is
  ///`isGranted` return `true`, else if permission is `isPermanentlyDenied` open
  ///app settings screen and return `false`, else if permission is not
  ///`isGranted` request to use location, if request is denied return `false`,
  ///else if granted return `true`.
  static Future<bool> getLocationPermission({
    bool requestPermission = true,
  }) async {
    late PermissionStatus serviceStatus;
    serviceStatus = await Permission.location.status;
    if (!requestPermission && !serviceStatus.isGranted) return false;
    if (serviceStatus.isPermanentlyDenied) {
      return false;
    }
    if (!serviceStatus.isGranted) {
      await Permission.location.request();
      serviceStatus = await Permission.location.status;
      if (!serviceStatus.isGranted) {
        return false;
      }
    }
    return true;
  }
}

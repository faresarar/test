// ignore_for_file: unused_import, unused_element

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitafit/firebase_options.dart';
import 'package:provider/provider.dart';

//Firebase
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'src/app.dart';
import 'src/mvc/model/enums/auth_state.dart';
import 'src/mvc/model/models.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channel_id', // id
  'channel_title', // title
  description: 'channel_description', // description
  importance: Importance.high,
  playSound: true,
  showBadge: true,
);

///Trigger this code when you recieve a notification while the app is on background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('_firebaseMessagingBackgroundHandler->${message.data.toString()}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsController settingsController =
      SettingsController(SettingsService());
  await settingsController.loadSettings();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
  );
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  UserSession userSession = UserSession.init(AuthState.awaiting);
  userSession.listenAuthStateChanges();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: userSession,
        ),
      ],
      child: MyApp(
        settingsController: settingsController,
      ),
    ),
  );
}

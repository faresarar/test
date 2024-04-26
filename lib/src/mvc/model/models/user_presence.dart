import 'dart:async';

import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../models_tools/bouncer.dart';

///Use `UserPresence` to update account owner's online status and last time
///he was seen, or to listen for users' online status.
class UserPresence with ChangeNotifier {
  UserPresence({
    required this.uid,
    required this.lastSeen,
    required this.presence,
  });

  final String uid;

  ///A time stamp that indicates when was the user last seen online
  int lastSeen;

  ///Indicates if the user is online or no
  bool presence;

  ///Used to subscribe to user's online status and notify widget listeners once
  ///it changes
  StreamSubscription? streamSubscription;

  ///Used to update user online status once each 15 minutes
  final Bouncer bouncer = Bouncer.fromMinutes(15);

  ///Create a `UserPresence` for user with [uid] and data in [json], and create a subscribtion
  ///to listen to changes in his online status.
  factory UserPresence.listenerFromJson(
      String uid, Map<Object?, Object?> json) {
    UserPresence user = UserPresence(
      uid: uid,
      lastSeen: json['last_seen'] as int? ?? 0,
      presence: json['presence'] as bool? ?? false,
    );
    user.activateListener();
    return user;
  }

  ///Create a `UserPresence` for user with [uid] that defaults [presence] to `false`.
  ///to listen to changes in his online status.
  factory UserPresence.listenerFromUserId(String uid) {
    UserPresence user = UserPresence(
      uid: uid,
      lastSeen: 0,
      presence: false,
    );
    user.activateListener();
    return user;
  }

  ///Create a `UserPresence` for account holder with [uid], Immediately update
  ///its online status `presence` to `true`, and attach a `bouncer` that updates
  ///`presence = true` and `last_seen = ServerTimeStamp` once each 15 minutes,
  ///and update it to `false` once the user disconnects.
  factory UserPresence.bouncerFromUserId(String uid) {
    UserPresence user = UserPresence(
      uid: uid,
      lastSeen: 0,
      presence: false,
    );
    //set online to true
    user.updatePresence(true);
    //activate on disconnect
    UserPresenceService.onDisconnect(uid: uid);
    //activate bouncer to activate presence each 15 min
    user.activateBouncer();
    return user;
  }

  Map<String, dynamic> toJson() => {
        'last_seen': lastSeen,
        'presence': presence,
      };

  ///Listen to changes to this user's `UserPresence` and notify listeners
  void activateListener() {
    if (streamSubscription != null) return;
    streamSubscription = UserPresenceService.listenUserPresence(
      uid: uid,
      onData: (event) {
        if (event.snapshot.exists) {
          copyWith(event.snapshot.value as Map<Object?, Object?>);
        } else {
          presence = false;
          lastSeen = 0;
        }
        notifyListeners();
      },
    );
  }

  ///Close listeners to this user's changes
  void cancelListener() {
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  void copyWith(Map<Object?, Object?> value) {
    Map<Object?, Object?> json = value;
    presence = json['presence'] as bool;
    lastSeen = json['last_seen'] as int;
    if (json['presence'] == true &&
        lastSeen < DateTime.now().millisecondsSinceEpoch - 900000) {
      presence = false;
    }
  }

  bool get showBadge => presence || lastSeen > 0;

  bool showTime(BuildContext context) => !presence;

  String getLastSeenString(BuildContext context) {
    if (presence) return ' ';
    return DateTimeUtils.of(context).formatElapsedDateTimeFromMilliseconds(
          lastSeen,
          false,
        ) ??
        '';
  }

  ///Run `updatePresence(true)` once every 15 minutes
  void activateBouncer() {
    bouncer.run(() {
      updatePresence(true);
    });
  }

  ///Cancel the bouncer
  void cancelBouncer() {
    bouncer.cancel();
  }

  ///Update user `presence` and `last_seen` a with `presence`= [value]
  Future<void> updatePresence(bool value) async {
    await UserPresenceService.updatePresence(
      uid: uid,
      isOnline: value,
    );
  }

  Future<void> disconnect() async {
    cancelBouncer();
    await updatePresence(false);
  }
}

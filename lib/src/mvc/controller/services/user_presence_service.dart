import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import '../../model/firebase_firestore_path.dart';

class UserPresenceService {
  static final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref();

  ///Activate onDisconnect for user with [uid], once the app is closed or killed
  ///update presence to false and also update last_seen timestamp.
  static void onDisconnect({required String uid}) {
    databaseReference
        .child(FirebaseFirestorePath.usersPresence(uid: uid))
        .onDisconnect()
        .update({
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> updatePresence({
    required String uid,
    required bool isOnline,
  }) async {
    await databaseReference
        .child(FirebaseFirestorePath.usersPresence(uid: uid))
        .set({
      'presence': isOnline,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static StreamSubscription<DatabaseEvent> listenUserPresence({
    required String uid,
    required void Function(DatabaseEvent) onData,
  }) {
    return databaseReference
        .child(FirebaseFirestorePath.usersPresence(uid: uid))
        .onValue
        .listen(
          onData,
        );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';

class AppNotificationsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<bool> listenNotifications(String uid) {
    return _firestore
        .collection(FirebaseFirestorePath.notifications(uid: uid))
        .where('seen', isEqualTo: false)
        .orderBy('createdAt')
        .limit(1)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }

  static Stream<bool> listenNotificationsArtisan(String uid) {
    return _firestore
        .collection(FirebaseFirestorePath.notifications(uid: uid))
        .where('params.type', isEqualTo: 'artisan')
        .where('seen', isEqualTo: false)
        .orderBy('createdAt')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }

  // static Future<AppNotification> get(DocumentReference reference) async {
  //   throw Exception('Not implemented');
  //   // DocumentSnapshot doc = await reference.get();
  //   // if (!doc.exists || doc.data() == null) {
  //   //   throw FirebaseException(
  //   //     plugin: '',
  //   //     code: 'document-not-found',
  //   //   );
  //   // }
  //   // return JobPublished.fromDocumentSnapshot(doc);
  // }

  // static Future<void> getList({
  //   required ListAppNotifications listAppNotifications,
  //   required String uid,
  //   required int limit,
  //   required bool refresh,
  //   DocumentSnapshot? afterDocument,
  // }) async {
  //   // throw Exception('Not implemented');
  //   Query query = _firestore
  //       .collection(FirestorePath.notifications(uid: uid))
  //       .orderBy('createdAt', descending: true)
  //       .limit(limit);
  //   if (afterDocument != null) query = query.startAfterDocument(afterDocument);
  //   QuerySnapshot resultquery = await query.get();
  //   List<AppNotification> list = [];
  //   list.addAll(resultquery.docs
  //       .map((doc) => AppNotification.fromDocumentSnapshot(doc))
  //       .toList());
  //   listAppNotifications.updateList(
  //     list,
  //     resultquery.docs.length == limit,
  //     resultquery.docs.isEmpty ? null : resultquery.docs.last,
  //     refresh,
  //   );
  // }

  // static Future<void> markAsSeen(DocumentReference reference) async {
  //   await reference.update({
  //     'seen': true,
  //   });
  // }

  // static Future<BricoOrder> create({
  //   required AppNotification notification,
  // }) async {
  //   throw Exception('Not implemented');
  //   // DocumentReference<Map<String, dynamic>> docRef = await _firestore
  //   //     .collection(FirebasePath.notifications())
  //   //     .add(notification.toMap);
  //   // return await docRef
  //   //     .get()
  //   //     .then((doc) => BricoOrder.fromDocumentSnapshot(doc));
  // }
}

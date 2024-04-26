import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';
import '../../model/list_models.dart';
import '../../model/models.dart';
import '../services.dart';

class MedecinesService extends FirestoreService<Medecine> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  DocumentReference get docReference =>
      _firestore.collection(FirebaseFirestorePath.medecines()).doc();

  @override
  Future<void> update(Medecine element) async {
    await element.uploadPhotoFile();
    await _firestore
        .doc(FirebaseFirestorePath.medecine(id: element.id))
        .update(element.toMapUpdate);
  }

  @override
  Future<void> create(Medecine element) async {
    await element.uploadPhotoFile();
    await _firestore.doc(FirebaseFirestorePath.medecine(id: element.id)).set(
          element.toMapCreate,
        );
  }

  @override
  Future<void> delete(Medecine element) async {
    await element.reference.delete();
  }

  @override
  Future<void> getList({
    required ListFirestoreClasses<Medecine> list,
    required int limit,
    required bool refresh,
  }) async {
    Query query = _firestore
        .collection(FirebaseFirestorePath.medecines())
        .where('uid', isEqualTo: list.uid)
        .orderBy('name', descending: true)
        .limit(limit);
    if (!refresh && list.lastDoc != null) {
      query = query.startAfterDocument(list.lastDoc!);
    }
    QuerySnapshot resultquery = await query.get();
    List<Medecine> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => Medecine.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>),
        )
        .toList());
    list.updateList(
      result,
      resultquery.docs.length == limit,
      resultquery.docs.isEmpty ? null : resultquery.docs.last,
      refresh,
    );
  }
}

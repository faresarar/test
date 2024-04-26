import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';
import '../../model/list_models.dart';
import '../../model/models.dart';
import '../services.dart';

class PatientsService extends FirestoreService<Patient> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  DocumentReference get docReference =>
      _firestore.collection(FirebaseFirestorePath.patients()).doc();

  @override
  Future<void> update(Patient element) async {
    await element.reference.update(element.toMapUpdate);
  }

  @override
  Future<void> create(Patient element) async {
    await element.reference.set(element.toMapCreate);
  }

  @override
  Future<void> delete(Patient element) async {
    await element.reference.delete();
  }

  @override
  Future<void> getList({
    required ListFirestoreClasses<Patient> list,
    required int limit,
    required bool refresh,
  }) async {
    Query query = _firestore
        .collection(FirebaseFirestorePath.patients())
        .where('uid', isEqualTo: list.uid)
        .orderBy('firstName', descending: true)
        .limit(limit);
    if (!refresh && list.lastDoc != null) {
      query = query.startAfterDocument(list.lastDoc!);
    }
    QuerySnapshot resultquery = await query.get();
    List<Patient> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => Patient.fromDocumentSnapshot(
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

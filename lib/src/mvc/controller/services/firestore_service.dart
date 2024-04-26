import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/list_models.dart';

abstract class FirestoreService<T> {
  DocumentReference get docReference;

  Future<void> create(T element);

  Future<void> update(T element);

  Future<void> delete(T element);

  Future<void> getList({
    required ListFirestoreClasses<T> list,
    required int limit,
    required bool refresh,
  });
}

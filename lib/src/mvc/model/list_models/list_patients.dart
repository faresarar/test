import 'package:firebase_auth/firebase_auth.dart';

import '../../controller/services.dart';
import '../models.dart';
import 'list_firestore_classes.dart';

class ListPatients extends ListFirestoreClasses<Patient> {
  ListPatients({
    required super.uid,
    required super.limit,
  });

  factory ListPatients.fromUserSession(UserSession userSession) => ListPatients(
        uid: userSession.uid,
        limit: 15,
      );

  factory ListPatients.fromUser(User user) => ListPatients(
        uid: user.uid,
        limit: 15,
      );

  factory ListPatients.init() => ListPatients(
        uid: '',
        limit: 0,
      );

  @override
  Future<void> create(Patient element) async {
    await element.create();
    super.insert(element);
  }

  @override
  Future<void> delete(Patient element) async {
    await element.delete();
    super.remove(element);
  }

  @override
  Future<void> get({bool refresh = false, bool get = true}) async {
    if (super.isAwaiting(refresh: refresh, get: get, isGetMore: false)) return;
    await PatientsService().getList(
      list: this,
      limit: limit,
      refresh: refresh,
    );
  }

  @override
  Future<void> getMore({int? want}) async {
    if (isAwaiting(refresh: false, get: true, isGetMore: true)) return;
    notifyListeners();
    await PatientsService().getList(
      list: this,
      limit: limit,
      refresh: false,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import '../../controller/services.dart';
import '../models.dart';
import 'list_firestore_classes.dart';

class ListMedecines extends ListFirestoreClasses<Medecine> {
  ListMedecines({
    required super.uid,
    required super.limit,
  });

  factory ListMedecines.fromUserSession(UserSession userSession) =>
      ListMedecines(
        uid: userSession.uid,
        limit: 15,
      );

  factory ListMedecines.fromUser(User user) => ListMedecines(
        uid: user.uid,
        limit: 15,
      );

  factory ListMedecines.init() => ListMedecines(
        uid: '',
        limit: 0,
      );

  @override
  Future<void> create(Medecine element) async {
    await element.create();
    super.insert(element);
  }

  @override
  Future<void> delete(Medecine element) async {
    await element.delete();
    super.remove(element);
  }

  @override
  Future<void> get({bool refresh = false, bool get = true}) async {
    if (super.isAwaiting(refresh: refresh, get: get, isGetMore: false)) return;
    await MedecinesService().getList(
      list: this,
      limit: limit,
      refresh: refresh,
    );
  }

  @override
  Future<void> getMore({int? want}) async {
    if (isAwaiting(refresh: false, get: true, isGetMore: true)) return;
    notifyListeners();
    await MedecinesService().getList(
      list: this,
      limit: limit,
      refresh: false,
    );
  }
}

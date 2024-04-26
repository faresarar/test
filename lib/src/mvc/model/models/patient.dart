import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../models.dart';

class Patient extends FirebaseModel {
  String firstName;
  String lastName;
  String birthDate;
  final String uid;

  Patient({
    required super.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.uid,
    required super.createdAt,
    required super.updatedAt,
    required super.reference,
  });

  factory Patient.init({
    required UserSession userSession,
    required String firstName,
    required String lastName,
    required String birthDate,
  }) {
    DocumentReference reference = PatientsService().docReference;
    return Patient(
      id: reference.id,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      uid: userSession.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: reference,
    );
  }

  factory Patient.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      Patient(
        id: doc.id,
        firstName: doc.data()!['firstName'],
        lastName: doc.data()!['lastName'],
        birthDate: doc.data()!['birthDate'],
        uid: doc.data()!['uid'],
        createdAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['createdAt'])!,
        updatedAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['updatedAt'])!,
        reference: doc.reference,
      );

  @override
  Map<String, dynamic> get toMapCreate => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Map<String, dynamic> get toMapUpdate => {
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Future<void> update() async {
    await PatientsService().update(this);
    notifyListeners();
  }

  @override
  Future<void> create() async {
    await PatientsService().create(this);
  }

  @override
  Future<void> delete() async {
    await PatientsService().delete(this);
  }

  String get displayName => '$firstName $lastName';
}

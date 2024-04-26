import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../firebase_storage_path.dart';
import '../models.dart';

class Medecine extends FirebaseModel {
  String name;
  String description;
  String? photoUrl;
  ImageProvider<Object>? photo;
  final String uid;

  Medecine({
    required super.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.photo,
    required this.uid,
    required super.createdAt,
    required super.updatedAt,
    required super.reference,
  });

  factory Medecine.init({
    required UserSession userSession,
    required String name,
    required String description,
    required String? photoPath,
  }) {
    DocumentReference reference = MedecinesService().docReference;
    return Medecine(
      id: reference.id,
      name: name,
      description: description,
      photoUrl: photoPath,
      photo: photoPath.isNotNullOrEmpty ? Image.asset(photoPath!).image : null,
      uid: userSession.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: reference,
    );
  }

  factory Medecine.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      Medecine(
        id: doc.id,
        name: doc.data()!['name'],
        description: doc.data()!['description'],
        photoUrl: doc.data()!['photoUrl'],
        photo: (doc.data()!['photoUrl'] as String?).toImageProvider,
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
        'name': name,
        'description': description,
        'photoUrl': photoUrl,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Map<String, dynamic> get toMapUpdate => {
        'name': name,
        'description': description,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Future<void> update() async {
    await MedecinesService().update(this);
    notifyListeners();
  }

  @override
  Future<void> create() async {
    await MedecinesService().create(this);
  }

  @override
  Future<void> delete() async {
    await MedecinesService().delete(this);
  }

  Future<void> uploadPhotoFile() async {
    if (photoUrl.isNullOrEmpty) return;
    photoUrl = await ModernPicker.uploadImageFile(
      photoPath: photoUrl!,
      root: FirebaseStoragePath.medecineImages,
      fileName: id,
    );
    photo = CachedNetworkImageProvider(photoUrl!);
  }
}

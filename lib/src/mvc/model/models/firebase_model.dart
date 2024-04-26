import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class FirebaseModel with ChangeNotifier {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentReference reference;

  FirebaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.reference,
  });

  Map<String, dynamic> get toMapCreate;

  Map<String, dynamic> get toMapUpdate;

  Future<void> create();

  Future<void> update();

  Future<void> delete();
}

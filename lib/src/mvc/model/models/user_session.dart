import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../../view/screens.dart';
import '../enums.dart';
import '../firebase_storage_path.dart';
import '../list_models.dart';

class UserSession with ChangeNotifier {
  /// user authentication sate
  AuthState authState;
  Exception? error;

  /// user Id
  String uid;
  String? token;
  String? email;
  bool? emailVerified;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? adeli;
  String? photoUrl;
  CachedNetworkImageProvider? photo;
  String? signatureUrl;
  CachedNetworkImageProvider? signature;
  bool? isReviewedApp;
  DateTime? updatedAt;
  DateTime? createdAt;
  ListPatients listPatients;
  ListMedecines listMedecines;

  UserSession({
    required this.authState,
    required this.error,
    required this.uid,
    required this.token,
    required this.email,
    required this.emailVerified,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.adeli,
    required this.photo,
    required this.photoUrl,
    required this.signature,
    required this.signatureUrl,
    required this.isReviewedApp,
    required this.updatedAt,
    required this.createdAt,
    required this.listPatients,
    required this.listMedecines,
  });

  ///Use as build an inital instance of `UserSession` while waiting for response from
  ///stream `AuthenticationService.userStream`
  factory UserSession.init(AuthState authState) => UserSession(
        authState: authState,
        error: null,
        uid: '',
        token: null,
        email: null,
        emailVerified: null,
        firstName: null,
        lastName: null,
        birthDate: null,
        adeli: null,
        photo: null,
        photoUrl: null,
        signature: null,
        signatureUrl: null,
        isReviewedApp: null,
        updatedAt: null,
        createdAt: null,
        listPatients: ListPatients.init(),
        listMedecines: ListMedecines.init(),
      );

  ///Call and use to catch [error] when listening to stream `AuthenticationService.userStream`
  factory UserSession.error(dynamic error) => UserSession(
        authState: AuthState.awaiting,
        error: error,
        uid: '',
        token: null,
        email: null,
        emailVerified: null,
        firstName: null,
        lastName: null,
        birthDate: null,
        adeli: null,
        photo: null,
        photoUrl: null,
        signature: null,
        signatureUrl: null,
        isReviewedApp: null,
        updatedAt: null,
        createdAt: null,
        listPatients: ListPatients.init(),
        listMedecines: ListMedecines.init(),
      );

  ///Call after user signup to build a instance of user `profile`, that will be
  ///pushed later by calling `toInitMap` method.
  factory UserSession.fromUserCredential(
    UserCredential userCredential,
    String? token,
  ) =>
      UserSession.fromUser(userCredential.user!, token);

  ///Use to build an instance of `UserSession` from [user] and also using [token].
  factory UserSession.fromUser(
    User user,
    String? token,
  ) =>
      UserSession(
        authState: AuthState.authenticated,
        error: null,
        uid: user.uid,
        token: token,
        email: user.email,
        emailVerified: user.emailVerified,
        firstName: user.displayName,
        lastName: null,
        birthDate: null,
        adeli: null,
        photo: user.photoURL.toImageProvider,
        photoUrl: user.photoURL,
        signature: null,
        signatureUrl: null,
        isReviewedApp: null,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        listPatients: ListPatients.fromUser(user),
        listMedecines: ListMedecines.fromUser(user),
      );

  ///Use to build an instance of `UserSession` from [user] and [doc]
  factory UserSession.fromFirebaseUserDoc({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    Map<String, dynamic> json = doc.data()!;
    return UserSession(
      authState: AuthState.authenticated,
      error: null,
      uid: user.uid,
      email: user.email ?? json['email'],
      emailVerified: user.emailVerified,
      firstName: json['firstName'] ?? user.displayName,
      lastName: json['lastName'],
      birthDate: json['birthDate'],
      adeli: json['adeli'],
      token: json['token'],
      photo: (json['photoUrl'] as String?).toImageProvider,
      photoUrl: json['photoUrl'],
      signature: (json['signatureUrl'] as String?).toImageProvider,
      signatureUrl: json['signatureUrl'],
      isReviewedApp: json['isReviewedApp'] ?? false,
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt']),
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt']),
      listPatients: ListPatients.fromUser(user),
      listMedecines: ListMedecines.fromUser(user),
    );
  }

  ///Used only after user signup to create profile based on user credentials.
  ///`UserData.fromUserCredential` constructor is used to init UserData model
  ///after signup, then we use `toInitMap` to build a `document` in collection
  ///`userData` that needs to be pushed along side additional somedata
  Map<String, dynamic> get toMapCreate => {
        'uid': uid,
        'email': email,
        'token': token,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'adeli': adeli,
        'photoUrl': photoUrl,
        'signatureUrl': signatureUrl,
        'isReviewedApp': isReviewedApp,
        //initial params in userData document
        'updateKey': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapCreateUserMin => {
        'uid': uid,
        'email': email,
        'token': token,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapUpdate => {
        'email': email,
        'token': token,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'adeli': adeli,
        'photoUrl': photoUrl,
        'signatureUrl': signatureUrl,
        'isReviewedApp': isReviewedApp,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapDelete => {
        'email': email,
        'token': token,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'adeli': adeli,
        'photoUrl': photoUrl,
        'signatureUrl': signatureUrl,
        'isReviewedApp': isReviewedApp,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': Timestamp.fromDate(createdAt!),
      };

  bool get isReady => authState != AuthState.awaiting;
  bool get isAwaiting => authState == AuthState.awaiting;
  bool get isAuthenticated => authState == AuthState.authenticated;
  bool get isUnauthenticated => authState == AuthState.unauthenticated;

  bool get isProfileComplete =>
      firstName.isNotNullOrEmpty &&
      lastName.isNotNullOrEmpty &&
      birthDate.isNotNullOrEmpty &&
      adeli.isNotNullOrEmpty;

  bool get isProfileNotComplete =>
      firstName.isNullOrEmpty ||
      lastName.isNullOrEmpty ||
      birthDate.isNullOrEmpty ||
      adeli.isNullOrEmpty;

  String? get displayname =>
      lastName.isNullOrEmpty ? firstName : '${firstName ?? ''} ${lastName!}';

  void updateException(Exception? exception) {
    error = exception;
    notifyListeners();
  }

  void copyFromUserSession(UserSession update) {
    authState = update.authState;
    error = update.error;
    uid = update.uid;
    token = update.token;
    email = update.email;
    emailVerified = update.emailVerified;
    firstName = update.firstName;
    lastName = update.lastName;
    birthDate = update.birthDate;
    adeli = update.adeli;
    photo = update.photo;
    photoUrl = update.photoUrl;
    signature = update.signature;
    signatureUrl = update.signatureUrl;
    isReviewedApp = update.isReviewedApp;
    updatedAt = update.updatedAt;
    createdAt = update.createdAt;
    listPatients = ListPatients.fromUserSession(update);
    listMedecines = ListMedecines.fromUserSession(update);
    notifyListeners();
  }

  Future<void> listenAuthStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        if (user == null) {
          // user is not connected
          copyFromUserSession(
            UserSession.init(AuthState.unauthenticated),
          );
        } else {
          // user is connected
          try {
            UserSession userdata =
                await AuthenticationService.userFromFirebaseUser(user);
            copyFromUserSession(userdata);
          } on Exception catch (e) {
            updateException(e);
          }
        }
      },
    );
  }

  Future<void> signOut() async {
    await AuthenticationService.signOut(this);
  }

  Future<void> refreshisEmailVerified() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await FirebaseAuth.instance.currentUser!.reload();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (emailVerified == true) {
      notifyListeners();
    }
  }

  Future<void> updateIsReviewed() async {
    isReviewedApp = true;
    await UserSessionService.update(
      uid,
      toMapUpdate,
    );
  }

  Future<void> completeProfile({
    String? photoPath,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? adeli,
    Uint8List? signiture,
  }) async {
    if (photoPath.isNotNullOrEmpty) {
      photoUrl = await ModernPicker.uploadImageFile(
        photoPath: photoPath!,
        root: FirebaseStoragePath.profileImages,
        fileName: uid,
      );
      photo = CachedNetworkImageProvider(photoUrl!);
    }
    if (signiture != null) {
      signatureUrl = await ModernPicker.uploadImageData(
        imageData: signiture,
        root: FirebaseStoragePath.profileImages,
        fileName: uid,
      );
      signature = CachedNetworkImageProvider(signatureUrl!);
    }
    if (firstName != null) {
      this.firstName = firstName;
    }
    if (lastName != null) {
      this.lastName = lastName;
    }
    if (birthDate != null) {
      this.birthDate = birthDate;
    }
    if (adeli != null) {
      this.adeli = adeli;
    }
    await UserSessionService.update(
      uid,
      toMapUpdate,
    );
    notifyListeners();
  }

  void openProfileComplete(BuildContext context) => context.push(
        widget: ProfileComplete(userSession: this),
      );

  void openProfileInformation(BuildContext context) => context.push(
        widget: ProfileInformation(userSession: this),
      );

  void openProfileSignature(BuildContext context) => context.push(
        widget: ProfileSignature(userSession: this),
      );

  void openProfile(BuildContext context) {}
}

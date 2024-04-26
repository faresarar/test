import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/models.dart';
import '../services.dart';

class GoogleSignInService {
  static Future<void> signIn(UserSession userSession) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        // 'https://www.googleapis.com/auth/user.phonenumbers.read',
        // 'https://www.googleapis.com/auth/user.birthday.read',
        // 'https://www.googleapis.com/auth/user.addresses.read',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();
    if (googleUser == null) {
      return;
      // throw FirebaseException(code: 'sign-in-canceled', plugin: '');
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
    if (userCredential.user != null) {
      AuthenticationService.onSignInWithCredential(
        userCredential: userCredential,
        userSession: userSession,
      );
    }
  }
}

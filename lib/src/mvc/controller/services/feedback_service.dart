import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';
import '../../model/models.dart';

class FeedbackService {
  // static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> create({
    required UserSession userSession,
    required String message,
  }) async {
    await _firestore.collection(FirebaseFirestorePath.feedbacks()).doc().set(
      {
        ...userSession.toMapCreateUserMin,
        'message': message,
      },
    );
  }
}

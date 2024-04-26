class FirebaseFirestorePath {
  static String usersPresences() => 'usersPresence/';
  static String usersPresence({required String uid}) => 'usersPresence/$uid/';

  static String userSessions() => 'userSession/';
  static String userSession({required String uid}) => 'userSession/$uid';

  static String patients() => 'patients/';
  static String patient({required String id}) => 'patients/$id';

  static String medecines() => 'medecines/';
  static String medecine({required String id}) => 'medecines/$id';

  static String deletedUserSessions() => 'deletedUserSession/';
  static String deletedUserSession({required String uid}) =>
      'deletedUserSession/$uid';

  static String notifications({required String uid}) =>
      'userSession/$uid/notifications/';
  static String notification({required String uid, required String id}) =>
      'userSession/$uid/notifications/$id';

  static String feedbacks() => 'feedback/';
  static String feedback({required String id}) => 'feedback/$id';

  static String chats() => 'chats/';
  static String chat({required String uid}) => 'chats/$uid';

  static String messages({required String chatId}) => 'chats/$chatId/messages/';
  static String message({required String chatId, required String messageId}) =>
      'chats/$chatId/messages/$messageId';
}

abstract class FirebaseConstants {
  static const String apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY_WEB',
    defaultValue: '',
  );

  static const String appId = String.fromEnvironment(
    'FIREBASE_APP_ID_WEB',
    defaultValue: '',
  );

  static const String messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );

  static const String projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const String authDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: '',
  );

  static const String storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );
}

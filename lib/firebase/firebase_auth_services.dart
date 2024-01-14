import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true; // logout successful
    } catch (e) {
      log("Logout error: $e");
      return false; // logout failed
    }
  }
}

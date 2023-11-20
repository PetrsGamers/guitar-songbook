import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Login successful
    } catch (e) {
      print("Login error: $e");
      return false; // Login failed
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true; // logout successful
    } catch (e) {
      print("Logout error: $e");
      return false; // logout failed
    }
  }
}

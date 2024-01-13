import 'package:flutter/cupertino.dart';

class AuthController with ChangeNotifier {
  bool isLoggedIn = false;

  void signIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void signOut() {
    isLoggedIn = false;
    notifyListeners();
  }
}

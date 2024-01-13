// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';

class AuthController with ChangeNotifier {
//Within this section, you can integrate authentication methods
//such as Firebase, SharedPreferences, and more.

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

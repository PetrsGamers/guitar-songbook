import 'dart:js';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_auth_services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> LogIn(email, password) async {
    await Auth().loginUser(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Email'),
                  controller: _controllerEmail,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                  controller: _controllerPassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                  onPressed: () {
                    LogIn(_controllerEmail.text, _controllerPassword.text);
                    context.go('/search');
                  },
                  child: Text('login')),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                  onPressed: () => context.go('/register'),
                  child: Text('register')),
            )
          ],
        ),
      ),
    );
  }
}

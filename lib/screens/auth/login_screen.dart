import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firebase/firebase_auth_services.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Future<bool> logIn(String email, String password) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: remove this autologin
    _controllerEmail.text = "c@c.com";
    _controllerPassword.text = "cccccc";
    final authController = ref.watch(authProvider);
    void login() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } catch (e) {
        print("Login error: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$e"),
        ));
        return;
      }
      authController.signIn();
      context.go('/search');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                  controller: _controllerPassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onSubmitted: (_) => {login()},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  // TODO: remove this autologin
                  autofocus: true,
                  onPressed: () async {
                    login();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('login'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 250,
                child: OutlinedButton(
                    onPressed: () => context.go('/register'),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Go to register screen'),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

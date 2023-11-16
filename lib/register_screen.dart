import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_auth_services.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> Register() async {
    await Auth().registerUser(
        email: _controllerEmail.text, password: _controllerPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Email'),
                  controller: _controllerEmail,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                  controller: _controllerPassword,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Auth().registerUser(
                        email: _controllerEmail.text,
                        password: _controllerPassword.text);
                    context.go('/login');
                  },
                  child: Text('register')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text('login')),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controllerEmail,
            ),
            TextField(
              controller: _controllerPassword,
            ),
            ElevatedButton(onPressed: Register, child: Text('register'))
          ],
        ),
      ),
    );
  }
}

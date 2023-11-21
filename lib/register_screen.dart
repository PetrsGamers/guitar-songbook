import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_auth_services.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUser(name, email, bio) {
      User? currentUser = Auth().currentUser;
      if (currentUser == null) {
        print("error adding user, the currentUser in Auth session is null");
        return Future(() => null);
      }
      print("user Auth id is: ${currentUser.uid}");
      return users
          .doc(currentUser
              .uid) // create a new user with the same id as the auth_id
          .set({
            'name': name,
            'email': email,
            'bio': bio,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

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
                  onPressed: () async {
                    if (await Auth().registerUser(
                            email: _controllerEmail.text,
                            password: _controllerPassword.text) ==
                        true) {
                      await addUser("placeholder_nickname",
                          _controllerEmail.text, "ahoj :)");
                      context.go('/login');
                    }
                  },
                  child: Text('register')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text('Go back to login screen')),
            )
          ],
        ),
      ),
    );
  }
}

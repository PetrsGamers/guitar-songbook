import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../firebase/firebase_auth_services.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Timer? _debounce;
  bool? isUsernameAvailable;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _controllerUsername.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onUsernameChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      checkUsernameAvailability(_controllerUsername.text);
    });
  }

  void checkUsernameAvailability(String username) async {
    if (_controllerUsername.text.isEmpty) {
      setState(() {
        isUsernameAvailable = false;
        errorMessage = "Invalid username";
      });
      return;
    }
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .limit(1)
        .get();

    setState(() {
      isUsernameAvailable = querySnapshot.docs.isEmpty;
      errorMessage = "Name already taken";
    });
  }

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

    void register() async {
      try {
        // don't you dare forget await here or anywhere else 💀💀💀
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } catch (e) {
        print("error registering the user: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$e"),
        ));
        return;
      }
      await addUser(
          _controllerUsername.text, _controllerEmail.text, "no bio available");
      context.go('/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                    labelText: 'User name',
                    errorText:
                        isUsernameAvailable == false ? errorMessage : null,
                    suffixIcon: isUsernameAvailable == null
                        ? null
                        : isUsernameAvailable!
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.error, color: Colors.red),
                  ),
                  controller: _controllerUsername,
                ),
              ),
            ),
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
                  onSubmitted: (_) => {register()},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      register();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('register'),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: OutlinedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Go back to login screen'),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

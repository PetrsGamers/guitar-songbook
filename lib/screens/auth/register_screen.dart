import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/auth/register_validator.dart';

import '../../firebase/firebase_auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Timer? _debounce;
  bool? _isUsernameAvailable;
  String _errorMessage = "";

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
      _checkUsernameAvailability(_controllerUsername.text);
    });
  }

  void _checkUsernameAvailability(String username) async {
    if (_controllerUsername.text.isEmpty) {
      setState(() {
        _isUsernameAvailable = false;
        _errorMessage = "Invalid username";
      });
      return;
    }
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .limit(1)
        .get();

    setState(() {
      _isUsernameAvailable = querySnapshot.docs.isEmpty;
      _errorMessage = "Name already taken";
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUser(name, email, bio) {
      User? currentUser = Auth().currentUser;
      if (currentUser == null) {
        log("error adding user, the currentUser in Auth session is null");
        return Future(() => null);
      }
      log("user Auth id is: ${currentUser.uid}");
      return users
          .doc(currentUser
              .uid) // create a new user with the same id as the auth_id
          .set({
            'name': name,
            'email': email,
            'bio': bio,
          })
          .then((value) => log("User Added"))
          .catchError((error) => log("Failed to add user: $error"));
    }

    void register() async {
      try {
        // don't you dare forget await here or anywhere else 💀💀💀
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } catch (e) {
        log("error registering the user: $e");
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
        title: const Text('Register'),
      ),
      body: Center(
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: RegisterFormValidator.validateUsername,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Username',
                      labelText: 'User name',
                      errorText:
                          _isUsernameAvailable == false ? _errorMessage : null,
                      suffixIcon: _isUsernameAvailable == null
                          ? null
                          : _isUsernameAvailable!
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.error, color: Colors.red),
                    ),
                    controller: _controllerUsername,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: RegisterFormValidator.validateEmail,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    controller: _controllerEmail,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    obscureText: true,
                    validator: RegisterFormValidator.validatePassword,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Password'),
                    controller: _controllerPassword,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!(_registerFormKey.currentState!.validate())) {
                          print("validation failed");
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registering user')));
                        register();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
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
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Go back to login screen'),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

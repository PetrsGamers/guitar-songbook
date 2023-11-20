import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/login_screen.dart';
import 'package:guitar_app/songs_class.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_services.dart';
import 'searchbox.dart';

// placeholder screen, replace with your own screen implementation
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.content});
  final User? user = Auth().currentUser;
  final String content;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search song screen"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: [
              SearchBox(),
              Text(content),
              Text(user?.email ?? 'nouser'),
              ElevatedButton(
                  onPressed: () {
                    // this is an example route to showcase the stack navigator working
                    // alongside the bottom / rail navbar
                    context.goNamed("Search details");
                  },
                  child: const Text("Push a stack screen (details or sth)")),
              ElevatedButton(
                  onPressed: () {
                    signOut();
                    context.go('/login');
                  },
                  child: Text('logout'))
            ],
          ),
        ));
  }
}

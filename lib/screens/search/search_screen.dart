import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/auth/login_screen.dart';
import 'package:guitar_app/screens/settings/settings_screen.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_auth_services.dart';
import 'widgets/searchbox.dart';

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
          title: const Text("Search song"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: const Center(child: SearchBox()));
  }
}
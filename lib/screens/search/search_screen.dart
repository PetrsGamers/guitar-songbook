import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_auth_services.dart';
import 'widgets/searchbox.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search a song"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: const Center(child: SearchBox()));
  }
}

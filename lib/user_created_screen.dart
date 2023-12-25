import 'package:flutter/material.dart';

class UserCreatedScreen extends StatelessWidget {
  const UserCreatedScreen({super.key, required this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Created songs list")),
        body: Text("list of user id's [$userId] favorite songs"));
  }
}

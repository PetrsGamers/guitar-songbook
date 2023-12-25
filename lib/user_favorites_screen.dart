import 'package:flutter/material.dart';

class UserFavoritesScreen extends StatelessWidget {
  const UserFavoritesScreen({super.key, required this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Favorite songs list")),
        body: Text("list of user id's [${userId}] favorite songs"));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'firebase_auth_services.dart';

// placeholder screen, replace with your own screen implementation
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    bool viewingSelf = userId == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: 140,
            color: Colors.grey,
          ),
          Positioned(
            top: 80,
            right: 40,
            child: CircleAvatar(
              radius: 60, // The size of the avatar
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Google_favicon.png/640px-Google_favicon.png'), // Your image goes here
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: 140), // pad the top profile background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username_1992", style: TextStyle(fontSize: 32)),
                  SongListPreview(
                      viewingSelf: viewingSelf, listType: ListType.created),
                  SongListPreview(
                      viewingSelf: viewingSelf, listType: ListType.favorites)
                ],
              ))
        ],
      ),
    );
  }
}

class SongListPreview extends StatelessWidget {
  const SongListPreview({super.key, this.viewingSelf, required this.listType});

  final bool? viewingSelf;
  final ListType listType;

  @override
  Widget build(BuildContext context) {
    String widgetTitle;
    if (viewingSelf == true && listType == ListType.created) {
      widgetTitle = "Songs created by you";
    } else if (viewingSelf == true && listType == ListType.favorites) {
      widgetTitle = "Your favorite songs";
    } else if (listType == ListType.created) {
      widgetTitle = "Songs created by user";
    } else {
      widgetTitle = "User's favorite songs";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [Text(widgetTitle), Icon(Icons.arrow_forward_ios)],
            ),
          ),
          Text("song1"),
          Text("song2"),
          Text("song3"),
        ],
      ),
    );
  }
}

enum ListType { created, favorites }

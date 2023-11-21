import 'package:flutter/material.dart';
import 'package:guitar_app/profile_screen.dart';

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

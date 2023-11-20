import 'package:flutter/material.dart';
import 'package:guitar_app/app_user.dart';
import 'package:guitar_app/profile_screen.dart';
import 'package:guitar_app/song_list_preview.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.viewingSelf, required this.user});

  final bool viewingSelf;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          height: 140,
          color: Colors.lightGreen,
        ),
        Positioned(
          top: 80,
          right: 40,
          child: CircleAvatar(
            radius: 60, // The size of the avatar
            backgroundImage: NetworkImage(user.picture), // Your image goes here
            backgroundColor: Colors.transparent,
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: 140), // pad the top profile background
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: TextStyle(fontSize: 32)),
                SongListPreview(
                    viewingSelf: viewingSelf, listType: ListType.created),
                SongListPreview(
                    viewingSelf: viewingSelf, listType: ListType.favorites)
              ],
            ))
      ],
    );
  }
}

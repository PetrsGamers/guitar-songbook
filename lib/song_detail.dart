import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/songs_class.dart';
import 'detail_song_view.dart';
import 'favourite_checkbox.dart';
import 'firebase_auth_services.dart';

class SongDetail extends StatefulWidget {
  final Song song;
  const SongDetail({Key? key, required this.song}) : super(key: key);

  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.song.author),
            Row(
              children: [
                Text('Favourite ?'),
                FavouriteCheckbox(songId: widget.song.id),
              ],
            ),
            Expanded(
              child: DetailSongView(text: widget.song.text),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guitar_app/songs_class.dart';
import 'detail_song_view.dart';

class SongDetail extends StatelessWidget {
  final Song song;
  const SongDetail({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(song.name),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          child: Column(
            children: [Text(song.author), DetailSongView(text: song.text)],
          ),
        ));
  }
}

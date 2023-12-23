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
        padding: EdgeInsets.all(8.0), // Adjust padding here as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align widgets to the start of the column
          children: [
            Text(song.author),
            SizedBox(
                height: 8.0), // Add a sized box for vertical spacing if needed
            DetailSongView(text: song.text),
          ],
        ),
      ),
    );
  }
}

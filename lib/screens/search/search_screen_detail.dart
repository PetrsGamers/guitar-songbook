import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/screens/search/song_detail.dart';
import 'package:guitar_app/entities/songs.dart';

class SearchScreenDetail extends StatelessWidget {
  final songId;
  const SearchScreenDetail({Key? key, this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Song>(
      future: getSongbyId(songId),
      builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // TODO vymazat else(s)
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // TODO tady též
          return SongDetail(song: snapshot.data!);
        } else {
          return const Text('No song found');
        }
      },
    ));
  }
}

Future<Song> getSongbyId(String documentId) async {
  var firestore = FirebaseFirestore.instance;
  var songCollection = firestore.collection('songs');

  var documentSnapshot = await songCollection.doc(documentId).get();

  if (documentSnapshot.exists) {
    return Song.fromMap(
        documentId, documentSnapshot.data() as Map<String, dynamic>);
  } else {
    // Handle the case where the document does not exist
    throw Exception('Song not found $documentId');
  }
}

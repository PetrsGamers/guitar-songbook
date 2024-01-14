import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/screens/search/widgets/song_detail.dart';
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
          return Center(child: const CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return SongDetail(song: snapshot.data!);
        } else {
          return const Text('No song found');
        }
      },
    ));
  }
}

// TODO: toto extrahovat do extra service
Future<Song> getSongbyId(String documentId) async {
  var firestore = FirebaseFirestore.instance;
  var songCollection = firestore.collection('songs');

  var documentSnapshot = await songCollection.doc(documentId).get();

  if (documentSnapshot.exists) {
    return Song.fromMap(
        documentId, documentSnapshot.data() as Map<String, dynamic>);
  } else {
    throw Exception('Song not found $documentId');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/entities/songs_class.dart';

class FavoritePreview extends StatelessWidget {
  const FavoritePreview({super.key, required this.userId});
  final String userId;

  Future<List<Song>> getUserFavorites(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<String> songIds;
    if (userDoc.exists && userDoc.data()!['favorites'] is List) {
      // Return the list of favorite song IDs
      songIds = List<String>.from(userDoc.data()!['favorites']);
      songIds = songIds.reversed.toList();
      songIds = songIds.length > 3 ? songIds.sublist(0, 3) : songIds;
    } else {
      songIds = [];
    }
    try {
      // get a list of song objects based on the prev. fetched ids
      CollectionReference<Map<String, dynamic>> songsCollection =
          FirebaseFirestore.instance.collection('songs');

      List<Song> songs = [];

      for (String songId in songIds) {
        DocumentSnapshot<Map<String, dynamic>> songDoc =
            await songsCollection.doc(songId).get();

        if (songDoc.exists) {
          songs.add(
              Song.fromMap(songDoc.id, songDoc.data() as Map<String, dynamic>));
        }
      }
      return songs;
    } catch (error) {
      print('Error fetching songs: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: getUserFavorites(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  ListTile(
                      onTap: () => context.push("/profile/${userId}/favorites"),
                      title: Text("User favorites"),
                      trailing: Icon(Icons.arrow_forward_ios)),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var song = snapshot.data![index];
                        return ListTile(
                          onTap: () => context.push("/search/${song.id}"),
                          title: Text('Name: ${song.name}'),
                          subtitle: Text('Author: ${song.author}'),
                        );
                      })
                ],
              );
            }
          }),
    );
  }
}

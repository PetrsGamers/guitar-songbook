import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/entities/songs.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({super.key, required this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> userDocSnapshot) {
          if (userDocSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!userDocSnapshot.hasData || userDocSnapshot.data == null) {
            return const Center(
              child: Text('User data not found'),
            );
          }

          List<String> favoriteSongIds;
          if ((userDocSnapshot.data!.data() as Map<String, dynamic>)
                  .containsKey('favorites') ==
              false) {
            favoriteSongIds = [];
          } else {
            favoriteSongIds =
                List<String>.from(userDocSnapshot.data!.get('favorites'));
          }

          return StreamBuilder(
            stream: favoriteSongIds.isNotEmpty
                ? FirebaseFirestore.instance
                    .collection('songs')
                    .where(FieldPath.documentId, whereIn: favoriteSongIds)
                    .snapshots()
                : null, // Return null stream if favoriteSongIds is empty
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> songsSnapshot) {
              if (songsSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!songsSnapshot.hasData || songsSnapshot.data == null) {
                return const Center(
                  child: Text('Favorite songs not found'),
                );
              }

              List<Song> favoriteSongs =
                  songsSnapshot.data!.docs.map((DocumentSnapshot doc) {
                return Song.fromMap(doc.id, doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  Song song = favoriteSongs[index];
                  return ListTile(
                    onTap: () {
                      context.push("/search/${song.id}");
                    },
                    title: Text(song.name),
                    subtitle: Text(song.author),
                    // Add additional information as needed
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

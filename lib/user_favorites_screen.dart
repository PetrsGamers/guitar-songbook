import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/songs_class.dart';

class FavoriteSongsScreen extends StatelessWidget {
  FavoriteSongsScreen({super.key, required this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Songs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> userDocSnapshot) {
          if (userDocSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userDocSnapshot.hasData || userDocSnapshot.data == null) {
            return Center(
              child: Text('User data not found'),
            );
          }

          List<String> favoriteSongIds =
              List<String>.from(userDocSnapshot.data!.get('favorites') ?? []);

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('songs')
                .where(FieldPath.documentId, whereIn: favoriteSongIds)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> songsSnapshot) {
              if (songsSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!songsSnapshot.hasData || songsSnapshot.data == null) {
                return Center(
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
                    subtitle: Text(
                        '${song.author} - ${userDocSnapshot.data!.get('name')}'),
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

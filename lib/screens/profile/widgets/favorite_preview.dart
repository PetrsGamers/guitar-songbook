import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/entities/songs.dart';

class FavoritePreview extends StatelessWidget {
  const FavoritePreview(
      {super.key, required this.userId, required this.songList});
  final String userId;
  final List<Song> songList;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ListTile(
            onTap: () => context.push("/profile/$userId/favorites"),
            title: const Text("User favorites"),
            trailing: const Icon(Icons.arrow_forward_ios)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: songList.length,
            itemBuilder: (context, index) {
              var song = songList[index];
              return ListTile(
                onTap: () => context.push("/search/${song.id}"),
                title: Text(song.name),
                subtitle: Text('Author: ${song.author}'),
              );
            })
      ],
    ));
  }
}

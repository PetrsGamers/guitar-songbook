import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'songs_class.dart';

class SongsNotifier extends ChangeNotifier {
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  List<Song> filtered_songs = [];
  Future<void> getSongs(String query) async {
    QuerySnapshot querySnapshot = await songs.get();
    final allSongs = querySnapshot.docs
        .map((doc) =>
            doc.data() as Map<String, dynamic>?) // Cast to a nullable Map
        .where((data) =>
            data != null &&
            data['name'] != null &&
            data['name'].toString().contains(query)) // Null-safe checks
        .toList();
    print(allSongs);
    filtered_songs = allSongs.cast<Song>();
    notifyListeners();
  }
}

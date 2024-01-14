import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firebase/firebase_auth_services.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  List<Song> _filteredSongs = [];
  var _favouriteSongs = [];

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  final User? currentUser = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      fetchUserFavourites();
      final query = _controller.text;
      if (query.isNotEmpty) {
        final results = await getSongs(query);
        setState(() {
          _filteredSongs = results;
        });
      } else {
        setState(() {
          _filteredSongs = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 250,
            child: TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Start typing to search for song...',
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                bool isFavorite =
                    _favouriteSongs.contains(_filteredSongs[index].id);

                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      context.go('/search/${_filteredSongs[index].id}');
                    },
                    title: Text(_filteredSongs[index].name),
                    subtitle: Text(_filteredSongs[index].author),
                    trailing: isFavorite
                        ? const Icon(
                            IconData(0xe5f9, fontFamily: 'MaterialIcons'))
                        : null, // Set the icon only if it's a favorite
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Song>> getSongs(String query) async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    QuerySnapshot querySnapshot = await songs.get();

    final allSongs = querySnapshot.docs
        .map((doc) => Song.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return allSongs;
  }

  Future<void> fetchUserFavourites() async {
    try {
      DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

      if (usersnapshot.exists) {
        final Map<String, dynamic>? userData =
            usersnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          _favouriteSongs = (userData['favorites'] as List<dynamic>?)!;
        }
      }
    } catch (error) {
      log("Error fetching document: $error");
    }
  }
}

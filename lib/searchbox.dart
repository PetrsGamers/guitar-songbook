import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guitar_app/songs_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  List<Song> _filteredSongs = [];

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

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
          Container(
            width: 250,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
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
            height: MediaQuery.of(context).size.height -
                250, // Adjust height as needed
            child: ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(_filteredSongs[index].name),
                    subtitle: Text(_filteredSongs[index].author),
                    trailing:
                        Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
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
        .map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>))
        .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return allSongs;
  }
}

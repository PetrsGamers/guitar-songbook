import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/search/widgets/rating_widget.dart';
import 'package:guitar_app/entities/songs.dart';
import 'detail_song_view.dart';
import 'widgets/favourite_checkbox.dart';
import '../../firebase/firebase_auth_services.dart';

class SongDetail extends StatefulWidget {
  final Song song;

  const SongDetail({Key? key, required this.song}) : super(key: key);

  @override
  SongDetailState createState() => SongDetailState();
}

class SongDetailState extends State<SongDetail> {
  final User? currentUser = Auth().currentUser;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  void _startAutoScroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 5),
      curve: Curves.linear,
    );
  }

  void _stopAutoScroll() {
    _scrollController.animateTo(
      _scrollController.position.pixels,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    //TODO buggy initial scroll to botom of song
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isScrolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  widget.song.name,
                  style: const TextStyle(fontSize: 20.0),
                ),
                Text(
                  widget.song.author,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Rating Widget
                    RatingsubWidget(song: widget.song),
                    // Comments Button
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/search/${widget.song.id}/comments');
                            },
                            child: const Text("Comments"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: FavouriteCheckbox(songId: widget.song.id),
                        ),
                      ],
                    ),
                  ],
                ),
                // Favourite Checkbox
                // Centered song details
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 1),
                        DetailSongView(
                          text: widget.song.text,
                          songKey: widget.song.key,
                        ),
                        const SizedBox(width: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isScrolling = !_isScrolling;
            if (_isScrolling) {
              _startAutoScroll();
            } else {
              _stopAutoScroll();
            }
          });
        },
        child: _isScrolling
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}

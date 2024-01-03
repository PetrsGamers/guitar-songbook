import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/rating_widget.dart';
import 'package:guitar_app/songs_class.dart';
import 'detail_song_view.dart';
import 'favourite_checkbox.dart';
import 'firebase_auth_services.dart';

class SongDetail extends StatefulWidget {
  final Song song;

  const SongDetail({Key? key, required this.song}) : super(key: key);

  @override
  SongDetailState createState() => SongDetailState();
}

class SongDetailState extends State<SongDetail> {
  final User? currentUser = Auth().currentUser;
  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  void _startAutoScroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 5),
      curve: Curves.linear,
    );
  }

  void _stopAutoScroll() {
    _scrollController.animateTo(
      _scrollController.position.pixels,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
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
        title: Text(widget.song.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.song.author),
              Row(
                children: [
                  Text('Favourite ?'),
                  FavouriteCheckbox(songId: widget.song.id),
                ],
              ),
              RatingsubWidget(song: widget.song),
              ElevatedButton(
                  onPressed: () {
                    context.go('/search/${widget.song.id}/comments');
                  },
                  child: Text("Comments")),
              DetailSongView(
                text: widget.song.text,
                songKey: widget.song.key,
              ),
            ],
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
        child: _isScrolling ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }
}

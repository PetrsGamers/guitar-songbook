import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/search/widgets/rating_widget.dart';
import 'package:guitar_app/entities/songs.dart';
import '../../../entities/ratings.dart';
import 'detail_song_view.dart';
import 'favourite_checkbox.dart';
import '../../../firebase/firebase_auth_services.dart';

class SongDetail extends StatefulWidget {
  final Song song;
  final Rating rating;
  final double fullRating;
  const SongDetail(
      {Key? key,
      required this.song,
      required this.rating,
      required this.fullRating})
      : super(key: key);

  @override
  SongDetailState createState() => SongDetailState();
}

class SongDetailState extends State<SongDetail> {
  final User? _currentUser = Auth().currentUser;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  int songDuration = 0;

  int calculateSongDuration() {
    int songBpm;
    if (widget.song.bpm == "") {
      songBpm = 120; // default bpm in case of some db inconsistencies
    }
    songBpm = int.parse(widget.song.bpm);
    int textLength = widget.song.text.length;
    // compute the duration of the song based on the bpm and length of the text
    // -- to account for smaller influence of bpm on the perceived speed, we are
    // using log function to smooth out the difference between different bpm
    // values
    int songDuration = (textLength * 0.14 * (5 / log(songBpm))).round();
    return songDuration;
  }

  void _startAutoScroll() {
    double percentageScrolled = _scrollController.position.pixels /
        _scrollController.position.maxScrollExtent;
    double remainingPercentage = 1 - percentageScrolled;
    int remainingTime = (remainingPercentage * songDuration).round();
    if (remainingTime < 1) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: remainingTime),
      curve: Curves.linear,
    );
  }

  void _stopAutoScroll() {
    _scrollController.animateTo(
      _scrollController.position.pixels,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      songDuration = calculateSongDuration();
    });
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
                    RatingsubWidget(
                        song: widget.song,
                        rating: widget.rating,
                        fullRating: widget.fullRating),
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

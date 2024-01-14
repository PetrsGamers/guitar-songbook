import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/entities/ratings.dart';
import 'package:guitar_app/screens/search/services/rating_services.dart';
import 'package:guitar_app/screens/search/widgets/song_detail.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:guitar_app/screens/search/services/searchbox_services.dart';

import '../../common/handlingfuturebuilder.dart';

class SearchScreenDetail extends StatelessWidget {
  final songId;
  const SearchScreenDetail({Key? key, this.songId}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        body: HandlingFutureBuilder<Song>(
      future: SearchBoxServices.getSongbyId(songId),
      builder: (BuildContext context, Song? song) {
        if (song != null) {
          return HandlingFutureBuilder<Rating?>(
            future: RatingServices.fetchUserRating(songId),
            builder: (BuildContext context, Rating? rating) {
              Rating _rating =
                  rating ?? Rating(author: 'noone', number: -1, id: 'noone');

              return HandlingFutureBuilder<double>(
                future: RatingServices.updateFullRating(songId),
                builder: (BuildContext context, double? fullRating) {
                  double _fullRating = fullRating ?? -1;
                  return SongDetail(
                    song: song,
                    rating: _rating,
                    fullRating: _fullRating,
                  );
                },
              );
            },
          );
        } else {
          return const Text('No song found');
        }
      },
    ));
  }
}

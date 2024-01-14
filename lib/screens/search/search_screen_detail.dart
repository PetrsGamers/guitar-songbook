import 'package:flutter/material.dart';
import 'package:guitar_app/entities/ratings.dart';
import 'package:guitar_app/screens/search/services/rating_services.dart';
import 'package:guitar_app/screens/search/widgets/song_detail.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:guitar_app/screens/search/services/searchbox_services.dart';

import '../../common/handlingfuturebuilder.dart';

class SearchScreenDetail extends StatelessWidget {
  final String? songId;
  const SearchScreenDetail({Key? key, required this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (songId == null) {
      return const Text("SongId error: no song available");
    }
    return Scaffold(
        body: HandlingFutureBuilder<Song>(
      future: SearchBoxServices.getSongbyId(songId!),
      builder: (BuildContext context, Song? song) {
        if (song != null) {
          return HandlingFutureBuilder<Rating?>(
            future: RatingServices.fetchUserRating(songId),
            builder: (BuildContext context, Rating? rating) {
              Rating ratingObj =
                  rating ??= Rating(author: 'noone', number: -1, id: 'noone');

              return HandlingFutureBuilder<double>(
                future: RatingServices.updateFullRating(songId),
                builder: (BuildContext context, double? fullRating) {
                  fullRating ??= -1;
                  return SongDetail(
                    song: song,
                    rating: ratingObj,
                    fullRating: fullRating,
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

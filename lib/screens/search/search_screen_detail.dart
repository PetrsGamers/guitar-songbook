import 'package:flutter/material.dart';
import 'package:guitar_app/entities/ratings.dart';
import 'package:guitar_app/screens/search/services/rating_services.dart';
import 'package:guitar_app/screens/search/widgets/song_detail.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:guitar_app/screens/search/services/searchbox_services.dart';

class SearchScreenDetail extends StatelessWidget {
  final songId;
  const SearchScreenDetail({Key? key, this.songId}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Song>(
        future: SearchBoxServices.getSongbyId(songId),
        builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return FutureBuilder<Rating?>(
                future: RatingServices.fetchUserRating(songId),
                builder: (BuildContext context,
                    AsyncSnapshot<Rating?> ratingSnapshot) {
                  Rating _rating =
                      Rating(author: 'noone', number: -1, id: 'noone');

                  if (ratingSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }
                  if (ratingSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${ratingSnapshot.error}'));
                  }
                  if (ratingSnapshot.hasData) {
                    _rating = ratingSnapshot.data!;
                  }
                  return FutureBuilder<double>(
                      future: RatingServices.updateFullRating(songId),
                      builder: (BuildContext context,
                          AsyncSnapshot<double> fullRatingSnapshot) {
                        double fullRating = -1;
                        if (fullRatingSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: const CircularProgressIndicator());
                        }
                        if (fullRatingSnapshot.hasError) {
                          return Center(
                              child:
                                  Text('Error: ${fullRatingSnapshot.error}'));
                        }
                        if (fullRatingSnapshot.hasData) {
                          fullRating = fullRatingSnapshot.data!;
                        }
                        return SongDetail(
                            song: snapshot.data!,
                            rating: _rating,
                            fullRating: fullRating);
                      });
                });
          } else {
            return const Text('No song found');
          }
        },
      ),
    );
  }
}

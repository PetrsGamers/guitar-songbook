import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guitar_app/entities/ratings.dart';
import 'package:guitar_app/entities/songs.dart';

import '../../../firebase/firebase_auth_services.dart';

class RatingsubWidget extends StatefulWidget {
  final Song song;
  const RatingsubWidget({required this.song, Key? key}) : super(key: key);

  @override
  RatingWidgetState createState() => RatingWidgetState();
}

class RatingWidgetState extends State<RatingsubWidget> {
  final User? currentUser = Auth().currentUser;

  Rating? userRating;
  late Future<Rating?> _userRatingFuture;

  double fullRanking = -1;
  @override
  void initState() {
    super.initState();
    _userRatingFuture = fetchUserRating()!;
    updateFullRating();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Rating?>(
      future: fetchUserRating(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (!snapshot.hasData || snapshot.data == null) {
            userRating = Rating(author: 'noone', number: -1, id: 'noone');
          } else {
            userRating = snapshot.data!;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userRating?.number == -1)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _openRatingWindow,
                          child: const Text("Rate a song"),
                        ),
                      ),
                    ),
                  ],
                ),
              if (userRating?.number != -1)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: .0, bottom: 8.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _openRatingWindow,
                          child: Row(
                            children: [
                              Text(
                                  "Your rating: ${userRating!.number.toString()}"),
                              const Icon(IconData(0xe5f9,
                                  fontFamily: 'MaterialIcons')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if ('$fullRanking' != 'NaN' && fullRanking.toInt() >= 1)
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 18.0),
                  child: Row(
                    children: [
                      Text('User\'s rating: $fullRanking'),
                      const Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
                    ],
                  ),
                ),
              if (!('$fullRanking' != 'NaN' && fullRanking.toInt() >= 1))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(''),
                    ],
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  Future<Rating?> fetchUserRating() async {
    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.song.id)
          .collection('ratings');

      final authorRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

      final existingRating = await ratingCollectionRef
          .where('author', isEqualTo: authorRef)
          .limit(1)
          .get();

      final existingRatingDoc = existingRating.docs.first;
      final DocumentSnapshot ratingDocSnapshot =
          await existingRatingDoc.reference.get();
      final String authorPath = ratingDocSnapshot['author'].path;
      updateFullRating();
      return Rating(
        author: authorPath,
        id: ratingDocSnapshot.id,
        number: ratingDocSnapshot['rating'],
      );
    } catch (error) {
      log("No existing user-rating");
      return null;
    }
  }

  Future<void> deleteRating() async {
    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.song.id)
          .collection('ratings');

      final authorRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

      final existingRating = await ratingCollectionRef
          .where('author', isEqualTo: authorRef)
          .limit(1)
          .get();

      if (existingRating.size > 0) {
        final docIdToDelete = existingRating.docs.first.id;
        await ratingCollectionRef.doc(docIdToDelete).delete();
        setState(() {
          userRating = Rating(author: 'noone', number: -1, id: 'noone');
          updateFullRating();
        });
        Navigator.pop(context);
      }
    } catch (error) {
      log("Error deleting document: $error");
    }
  }

  void _openRatingWindow() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Column(
          children: [
            if (userRating?.number != null && userRating!.number != -1)
              ElevatedButton(
                onPressed: deleteRating,
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.red,
                ),
              ),
            RatingBar.builder(
              initialRating: userRating?.number ?? 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                updateRating(rating);
                Navigator.pop(context); // Close the modal
              },
            ),
          ],
        ));
      },
    );
  }

  Future<void> updateRating(double rating) async {
    try {
      final ratingCollectionRef2 = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.song.id)
          .collection('ratings');

      final authorRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

      final existingRating2 = await ratingCollectionRef2
          .where('author', isEqualTo: authorRef)
          .limit(1)
          .get();

      final ratingData = {
        'author': authorRef,
        'rating': rating,
      };
      if (existingRating2.docs.isEmpty) {
        await ratingCollectionRef2.add(ratingData);
        setState(() {
          userRating?.number = rating;
          userRating?.author = authorRef.path;
          updateFullRating();
        });
      } else {
        final existingRatingDoc2 = existingRating2.docs.first;
        final existingRatingRef2 = existingRatingDoc2.reference;
        await existingRatingRef2.update({'rating': rating});
        setState(() {
          userRating?.number = rating;
          updateFullRating();
        });
      }
    } catch (error) {
      log("Error updating document: $error");
    }
  }

  Future<void> updateFullRating() async {
    final ratingCollectionRef3 = FirebaseFirestore.instance
        .collection('songs')
        .doc(widget.song.id)
        .collection('ratings');

    return ratingCollectionRef3.get().then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        fullRanking = -1;
      } else {
        double totalRanking = 0;
        int count = 0;

        querySnapshot.docs.forEach((doc) {
          final rating = doc.data()['rating'];
          if (rating != null && rating is double) {
            totalRanking += rating;
            count++;
          }
        });

        if (count == 0) {
          // No valid rankings found in the documents
          fullRanking = -1;
        } else {
          fullRanking = totalRanking / count;
        }
      }
    }).catchError((error) {
      log("Error updating document: $error");
    });
  }
}

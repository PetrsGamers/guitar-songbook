import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guitar_app/ratings_class.dart';
import 'package:guitar_app/songs_class.dart';
import 'detail_song_view.dart';
import 'favourite_checkbox.dart';
import 'firebase_auth_services.dart';

class SongDetail extends StatefulWidget {
  final Song song;

  const SongDetail({Key? key, required this.song}) : super(key: key);

  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  final User? currentUser = Auth().currentUser;
  Rating? userRating;
  late Future<Rating?> _userRatingFuture;

  double fullRanking = -1;
  @override
  void initState() {
    super.initState();
    _userRatingFuture = fetchUserRating();
    updateFullRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<Rating?>(
        future: fetchUserRating(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or any loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (!snapshot.hasData || snapshot.data == null) {
              userRating = Rating(author: 'noone', number: -1, id: 'noone');
            } else {
              userRating = snapshot.data!;
            }
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.song.author),
                  Row(
                    children: [
                      Text('Favourite ?'),
                      FavouriteCheckbox(songId: widget.song.id),
                      if ('${fullRanking}' != 'NaN')
                        Row(
                          children: [
                            Text('Users rating of the song :  ${fullRanking}'),
                            Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
                          ],
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: openRatingWindow,
                        child: Text("Rate a song"),
                      ),
                      if (userRating?.number != -1)
                        Row(
                          children: [
                            Text(
                                "Your rating: ${userRating!.number.toString()}"),
                            Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
                          ],
                        ),
                    ],
                  ),
                  Expanded(
                    child: DetailSongView(text: widget.song.text),
                  ),
                ],
              ),
            );
          }
        },
      ),
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
      print("No existing user-rating");
      return null; // Return null if there's an error
    }
  }

  Future<void> DeleteRating() async {
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
        print('Document deleted successfully');
        setState(() {
          userRating = Rating(author: 'noone', number: -1, id: 'noone');
          updateFullRating();
        });
        Navigator.pop(context);
      } else {
        print('No document found matching the query');
      }
    } catch (error) {
      print("Error deleting document: $error");
    }
  }

  void openRatingWindow() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: Center(
          child: Column(
            children: [
              if (userRating?.number != null && userRating!.number != -1)
                ElevatedButton(
                  onPressed: DeleteRating,
                  child: Icon(
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
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  updateRating(rating);
                  updateFullRating();
                  Navigator.pop(context); // Close the modal
                },
              ),
            ],
          ),
        ));
      },
    );
  }

  Future<void> updateRating(double rating) async {
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

      final ratingData = {
        'author': authorRef, // Replace with the actual user ID
        'rating': rating, // Replace with the actual rating value
      };
      if (existingRating.docs.isEmpty) {
        await ratingCollectionRef.add(ratingData);
        setState(() {
          userRating?.number = rating;
          userRating?.author = authorRef.path;
        });
      } else {
        final existingRatingDoc = existingRating.docs.first;
        final existingRatingRef = existingRatingDoc.reference;
        await existingRatingRef.update({'rating': rating});
        setState(() {
          userRating?.number = rating;
          updateFullRating();
        });
      }
    } catch (error) {
      print("Error updating document: $error");
    }
  }

  Future<void> updateFullRating() async {
    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.song.id)
          .collection('ratings');

      final querySnapshot = await ratingCollectionRef.get();

      if (querySnapshot.docs.isEmpty) {
        fullRanking = -1;
      }

      double totalRanking = 0;
      int count = 0;

      querySnapshot.docs.forEach((doc) {
        final rating =
            doc.data()['rating']; // Replace 'ranking' with your field name
        if (rating != null && rating is double) {
          totalRanking += rating;
          count++;
        }
      });

      if (count == 0) {
        // No valid rankings found in the documents
        fullRanking = -1;
      }
      print('Total');
      print(totalRanking);
      fullRanking = totalRanking / count;
    } catch (error) {
      print("Error updating document: $error");
    }
  }
}

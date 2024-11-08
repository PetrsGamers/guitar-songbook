import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/ratings.dart';
import '../../../firebase/firebase_auth_services.dart';

class RatingServices {
  static Future<Rating?> fetchUserRating(songId) async {
    final User? currentUser = Auth().currentUser;

    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(songId)
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

  static Future<void> updateRating(double rating, songId) async {
    final User? currentUser = Auth().currentUser;

    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(songId)
          .collection('ratings');

      final authorRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

      final existingRating = await ratingCollectionRef
          .where('author', isEqualTo: authorRef)
          .limit(1)
          .get();

      final ratingData = {
        'author': authorRef,
        'rating': rating,
      };
      if (existingRating.docs.isEmpty) {
        await ratingCollectionRef.add(ratingData);
      } else {
        final existingRatingDoc = existingRating.docs.first;
        final existingRatingRef = existingRatingDoc.reference;
        await existingRatingRef.update({'rating': rating});
      }
    } catch (error) {
      log("Error updating document: $error");
    }
  }

  static Future<void> deleteRating(songId) async {
    final User? currentUser = Auth().currentUser;

    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(songId)
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
      }
    } catch (error) {
      log("Error deleting document: $error");
    }
  }

  static Future<double> updateFullRating(songId) async {
    final ratingCollectionRef = FirebaseFirestore.instance
        .collection('songs')
        .doc(songId)
        .collection('ratings');

    try {
      QuerySnapshot querySnapshot = await ratingCollectionRef.get();

      if (querySnapshot.docs.isEmpty) {
        return -1;
      } else {
        double totalRanking = 0;
        int count = 0;

        querySnapshot.docs.forEach((doc) {
          final rating = doc.get('rating');

          if (rating != null && rating is double) {
            totalRanking += rating;
            count++;
          }
        });

        if (count == 0) {
          return -1;
        } else {
          return totalRanking / count;
        }
      }
    } catch (error) {
      log("Error updating document: $error");
      return -1;
    }
  }
}

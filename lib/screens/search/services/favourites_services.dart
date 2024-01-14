import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../firebase/firebase_auth_services.dart';

class FavouritesServices {
  static Future<bool?> updateFavourites(bool newValue, songId) async {
    final User? currentUser = Auth().currentUser;

    if (newValue == true) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .update({
          'favorites': FieldValue.arrayUnion([songId])
        });
        return newValue; // Update the local state
      } catch (error) {
        print("Error updating document: $error");
      }
    } else {
      // Update Firebase Firestore based on the new value of the checkbox
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .update({
          'favorites': FieldValue.arrayRemove([songId])
        });
        return newValue;
        // Update the local state
      } catch (error) {
        print("Error updating document: $error");
      }
    }
  }

  static Future<bool> fetchUserFavourites(songId) async {
    final User? currentUser = Auth().currentUser;

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

      if (userSnapshot.exists) {
        final Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final List<dynamic>? favoriteIds =
              userData['favorites'] as List<dynamic>?;
          if (favoriteIds != null) {
            for (var favoriteId in favoriteIds) {
              if (favoriteId == songId) {
                return true;
              }
            }
          }
        }
      }

      return false;
    } catch (error) {
      print("Error fetching document: $error");
      return false;
    }
  }
}

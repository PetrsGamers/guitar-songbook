import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_auth_services.dart';

class FavouriteCheckbox extends StatefulWidget {
  final String songId;
  const FavouriteCheckbox({Key? key, required this.songId}) : super(key: key);

  @override
  _FavouriteCheckboxState createState() => _FavouriteCheckboxState();
}

class _FavouriteCheckboxState extends State<FavouriteCheckbox> {
  final User? currentUser = Auth().currentUser;
  late bool isChecked = false;

  @override
  void initState() {
    super.initState();
    fetchUserFavourites();
  }

  Future<void> fetchUserFavourites() async {
    try {
      DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

      if (usersnapshot.exists) {
        final Map<String, dynamic>? userData =
            usersnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final List<dynamic>? favoriteIds =
              userData['favorites'] as List<dynamic>?;
          print(favoriteIds);
          if (favoriteIds != null) {
            for (var favoriteId in favoriteIds) {
              // Assuming 'favoriteId' is the song ID and 'songId' is the current song's ID
              if (favoriteId == widget.songId) {
                setState(() {
                  isChecked = true; // Mark as checked if it matches
                });
                return;
              }
            }
          }
        }
      }
      setState(() {
        isChecked = false; // Mark as unchecked if not found
      });
    } catch (error) {
      print("Error fetching document: $error");
    }
  }

  Future<void> updateFavourites(bool newValue) async {
    if (newValue == true) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .update({
          'favorites': FieldValue.arrayUnion([widget.songId])
        });
        setState(() {
          isChecked = newValue; // Update the local state
        });
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
          'favorites': FieldValue.arrayRemove([widget.songId])
        });
        print('halo');
        setState(() {
          isChecked = newValue; // Update the local state
        });
      } catch (error) {
        print("Error updating document: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (!isChecked) Text('Add to favourite?'),
          if (isChecked) Text('Favourite'),
          Checkbox(
            value: isChecked,
            onChanged: (bool? newValue) {
              if (newValue != null) {
                updateFavourites(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}

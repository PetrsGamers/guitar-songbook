import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../firebase/firebase_auth_services.dart';
import 'package:guitar_app/screens/search/services/favourites_services.dart';

class FavouriteCheckbox extends StatefulWidget {
  final String songId;
  const FavouriteCheckbox({Key? key, required this.songId}) : super(key: key);

  @override
  FavouriteCheckboxState createState() => FavouriteCheckboxState();
}

class FavouriteCheckboxState extends State<FavouriteCheckbox> {
  late bool isChecked = false;

  @override
  void initState() {
    super.initState();
    FavouritesServices.fetchUserFavourites(widget.songId).then((isFavorite) {
      setState(() {
        isChecked = isFavorite;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isChecked) const Text('Add to favourite?'),
        if (isChecked) const Text('Favourite'),
        Checkbox(
          value: isChecked,
          onChanged: (bool? newValue) async {
            if (newValue != null) {
              bool? result = await FavouritesServices.updateFavourites(
                  newValue, widget.songId);
              setState(() {
                isChecked = result ?? isChecked;
              });
            }
          },
        ),
      ],
    );
  }
}

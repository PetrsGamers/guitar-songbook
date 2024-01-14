import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guitar_app/entities/ratings.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:guitar_app/screens/search/services/rating_services.dart';

import '../../../firebase/firebase_auth_services.dart';

class RatingsubWidget extends StatefulWidget {
  final Song song;
  final Rating rating;

  final double fullRating;
  const RatingsubWidget(
      {required this.song,
      required this.rating,
      required this.fullRating,
      Key? key})
      : super(key: key);

  @override
  RatingWidgetState createState() => RatingWidgetState();
}

class RatingWidgetState extends State<RatingsubWidget> {
  final User? _currentUser = Auth().currentUser;

  Rating? _userRating;
  double _fullRanking = -1;
  @override
  void initState() {
    super.initState();
    _userRating = widget.rating;
    _fullRanking = widget.fullRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_userRating?.number == -1)
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
        if (_userRating?.number != -1)
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
                        Text("Your rating: ${_userRating!.number.toString()}"),
                        const Icon(
                            IconData(0xe5f9, fontFamily: 'MaterialIcons')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        if ('$_fullRanking' != 'NaN' && _fullRanking.toInt() >= 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 18.0),
            child: Row(
              children: [
                Text('User\'s rating: $_fullRanking'),
                const Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
              ],
            ),
          ),
        if (!('$_fullRanking' != 'NaN' && _fullRanking.toInt() >= 1))
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

  void _openRatingWindow() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
              child: Column(
            children: [
              if (_userRating?.number != null && _userRating!.number != -1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 175,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        await RatingServices.deleteRating(widget.song.id);
                        var fullRanking2 =
                            await RatingServices.updateFullRating(
                                widget.song.id);
                        setState(() {
                          _userRating =
                              Rating(author: 'noone', number: -1, id: 'noone');
                          _fullRanking = fullRanking2;
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Remove rating'),
                          const Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RatingBar.builder(
                  initialRating: _userRating?.number ?? 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) async {
                    await RatingServices.updateRating(rating, widget.song.id);
                    var fullRanking2 =
                        await RatingServices.updateFullRating(widget.song.id);
                    setState(() {
                      _userRating?.number = rating;
                      _fullRanking = fullRanking2;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )),
        );
      },
    );
  }
}

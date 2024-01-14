import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/common/helpers.dart';
import 'package:guitar_app/screens/create/widgets/add_metadata.dart';
import 'package:guitar_app/screens/create/widgets/add_text.dart';
import 'package:guitar_app/screens/create/widgets/annotate.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';

class CreateSongScreen extends StatefulWidget {
  const CreateSongScreen({Key? key}) : super(key: key);

  @override
  State<CreateSongScreen> createState() => _CreateSongScreenState();
}

class _CreateSongScreenState extends State<CreateSongScreen> {
  int _subScreenIndex = 0;
  String _text = "";
  List<Map<int, String>> _annotationsList = [];

  void _submitSongToServerCallback(String songName, String musician, String bpm,
      String year, String songKey) {
    String serializedAnnotatedText = serializeLyrics(_text, _annotationsList);
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    songs.add({
      'name': songName,
      'author': musician,
      'bpm': bpm,
      'year': year,
      'userId': Auth().currentUser!.uid,
      'text': serializedAnnotatedText,
      'key': songKey,
    }).then((DocumentReference doc) {
      // add the song id to the user's list of created songs
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().currentUser!.uid);
      userRef
          .update({
            'created': FieldValue.arrayUnion([doc.id]),
          })
          .then(
              (value) => log("Added new entry in the user's \"created\" songs"))
          .catchError(
              (error) => log("Failed to add song to user's created: $error"));
      // redirect user to the detail screen of the song
      context.go("/search/${doc.id}");
    }).catchError((error) => print("Failed to add song: $error"));
    setState(() {
      _annotationsList = [];
      _text = "";
    });
  }

  void _goToNextSubScreenCallback(bool proceedNormally) {
    setState(() {
      if (!proceedNormally) {
        // in case the user wishes to go back to the starting screen
        // the state remains saved when needing to do some editing tho
        // the data gets flushed only on song submit
        _subScreenIndex = 0;
        return;
      }
      _subScreenIndex++;
      if (_subScreenIndex > 2) {
        _subScreenIndex = 0;
      }
    });
  }

  void _saveTextCallback(String lyrics) {
    setState(() {
      _text = lyrics;
    });
  }

  void _saveAnnotationsCallback(List<Map<int, String>> annotations) {
    setState(() {
      _annotationsList = annotations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new song - Step ${_subScreenIndex + 1} / 3'),
      ),
      body: Center(
          child: <Widget>[
        AddText(
            text: _text,
            nextScreenCallback: _goToNextSubScreenCallback,
            saveText: _saveTextCallback),
        Annotate(
            text: _text,
            nextScreenCallback: _goToNextSubScreenCallback,
            saveAnnotations: _saveAnnotationsCallback),
        AddMetadata(
            nextScreenCallback: _goToNextSubScreenCallback,
            onSubmit: _submitSongToServerCallback)
      ][_subScreenIndex]),
    );
  }
}

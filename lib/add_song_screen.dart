import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/add_metadata.dart';
import 'package:guitar_app/add_text.dart';
import 'package:guitar_app/annotate.dart';
import 'package:guitar_app/firebase_auth_services.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({Key? key}) : super(key: key);

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  int subScreenIndex = 0;
  String text = "";
  List<Map<int, String>> annotationsList = [];

  String serializeLyrics() {
    // clean the text from curly braces
    String cleanText = text.replaceAll(RegExp(r'[{}]', multiLine: true), '');
    List<String> lines = cleanText.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (i < annotationsList.length) {
        Map<int, String> annotations = annotationsList[i];
        List<int> sortedIndices = annotations.keys.toList()..sort();

        for (int j = sortedIndices.length - 1; j >= 0; j--) {
          int index = sortedIndices[j];
          String chord = annotations[index]!;
          lines[i] = lines[i].substring(0, index) +
              '{$chord}' +
              lines[i].substring(index);
        }
      }
    }
    return lines.join('\n');
  }

  void sumbitSongToServerCallback(String songName, String musician, String bpm,
      String year, String songKey) {
    // 1) parse the data into db-friendly format
    String serializedAnnotatedText = serializeLyrics();
    // 2) save the data properly
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    songs.add({
      'name': songName,
      'author': musician,
      'bpm': bpm,
      'year': year,
      'userId': Auth().currentUser!.uid,
      'text': serializedAnnotatedText,
      'key': songKey
    }).then((DocumentReference doc) {
      print("New song added");
      // redirect user to the detail screen of the song
      context.go("/search/${doc.id}");
    }).catchError((error) => print("Failed to add song: $error"));

    // 3) clear out state
    setState(() {
      annotationsList = [];
      text = "";
    });
  }

  void goToNextSubScreenCallback(bool proceedNormally) {
    setState(() {
      if (!proceedNormally) {
        // in case the user wishes to go back to the starting screen
        // the state remains saved when needing to do some editing tho
        // the data gets flushed only on song submit
        subScreenIndex = 0;
        return;
      }
      subScreenIndex++;
      if (subScreenIndex > 2) {
        subScreenIndex = 0;
      }
    });
  }

  void saveTextCallback(String lyrics) {
    setState(() {
      text = lyrics;
    });
  }

  void saveAnnotationsCallback(List<Map<int, String>> annotations) {
    setState(() {
      annotationsList = annotations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new song - step ${subScreenIndex + 1}/3'),
      ),
      body: Center(
          child: <Widget>[
        AddText(
            text: text,
            nextScreenCallback: goToNextSubScreenCallback,
            saveText: saveTextCallback),
        Annotate(
            text: text,
            nextScreenCallback: goToNextSubScreenCallback,
            saveAnnotations: saveAnnotationsCallback),
        AddMetadata(
            nextScreenCallback: goToNextSubScreenCallback,
            onSubmit: sumbitSongToServerCallback)
      ][subScreenIndex]),
    );
  }
}

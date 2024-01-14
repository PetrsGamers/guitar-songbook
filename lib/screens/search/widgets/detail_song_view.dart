import 'package:flutter/material.dart';
import 'package:guitar_app/entities/chord.dart';
import 'package:guitar_app/screens/search/songview_helpers.dart';

class DetailSongView extends StatefulWidget {
  const DetailSongView({
    Key? key,
    required this.text,
    required this.songKey,
  }) : super(key: key);

  final String text;
  final String songKey;
  static int circleOfFifthsLen = 12;

  @override
  State<DetailSongView> createState() => _DetailSongViewState();
}

class _DetailSongViewState extends State<DetailSongView> {
  late Chord songKeyChord = Chord(widget.songKey);
  int transposition = 0;

  @override
  Widget build(BuildContext context) {
    final linesString =
        widget.text.replaceAll("\\n", "\n"); // set right newlines
    List<String> lines = linesString.split('\n'); //split by new lines
    List<Widget> textWidgets = []; // Store widgets to display
    textWidgets.add(buildTransposer());
    for (var line in lines) {
      final separatedText = separateText(line);
      final transposedChords = transposeSong(transposition, separatedText);
      final distance = charDistancesBetweenBrackets(line);
      final annotationTextWithSpaces =
          addSpacesCountWithDistances(transposedChords, distance);
      textWidgets.add(
        Text(
          annotationTextWithSpaces,
          style: const TextStyle(fontFamily: "Monospace", fontSize: 17),
        ),
      );
      textWidgets.add(
        Text(
          separatedText[1],
          style: const TextStyle(fontFamily: "Monospace", fontSize: 17),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textWidgets.isNotEmpty ? textWidgets : [const Text("")],
    );
  }

  Row buildTransposer() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  transposition =
                      (transposition - 1) % DetailSongView.circleOfFifthsLen;
                  if (widget.songKey == "") {
                    return;
                  }
                  songKeyChord.transpose(-1);
                });
              },
              child: const Icon(Icons.arrow_downward)),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(songKeyChord.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(formatTransposition(transposition)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  transposition =
                      (transposition + 1) % DetailSongView.circleOfFifthsLen;
                  if (widget.songKey == "") {
                    return;
                  }
                  songKeyChord.transpose(1);
                });
              },
              child: const Icon(Icons.arrow_upward)),
        )
      ],
    );
  }
}

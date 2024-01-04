import 'package:flutter/material.dart';
import 'package:guitar_app/entities/chord.dart';

class ChordModal extends StatelessWidget {
  final String character;
  final int lineIndex;
  final int charIndex;
  final Function annotateChar;

  const ChordModal(
      {super.key,
      required this.character,
      required this.lineIndex,
      required this.charIndex,
      required this.annotateChar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Select Chord for $lineIndex "$character", index: $charIndex:'),
          for (String chord in Chord.circleOfFifths)
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // generate major and minor chord buttons
              ElevatedButton(
                onPressed: () {
                  annotateChar(lineIndex, charIndex, chord);
                  Navigator.pop(context);
                },
                child: Text(chord),
              ),
              ElevatedButton(
                  onPressed: () {
                    annotateChar(lineIndex, charIndex, "${chord}m");
                    Navigator.pop(context);
                  },
                  child: Text("${chord}m"))
            ]),
        ],
      ),
    );
  }
}

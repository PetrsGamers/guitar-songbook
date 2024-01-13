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
    return ListView(children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Select chord again to remove the annotation.'),
            ),
            for (String chord in Chord.circleOfFifths)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // generate major and minor chord buttons
                      SizedBox(
                        width: 90,
                        child: ElevatedButton(
                          onPressed: () {
                            annotateChar(lineIndex, charIndex, chord);
                            Navigator.pop(context);
                          },
                          child: Text(chord),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: ElevatedButton(
                            onPressed: () {
                              annotateChar(lineIndex, charIndex, "${chord}m");
                              Navigator.pop(context);
                            },
                            child: Text("${chord}m")),
                      )
                    ]),
              ),
          ],
        ),
      ),
    ]);
  }
}

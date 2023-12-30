import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:guitar_app/chord.dart';

class AnnotateScreen extends StatefulWidget {
  AnnotateScreen({super.key, required this.text})
      : listMap = _createListMapFromText(text);
  final String text;

  final List<Map<int, String>> listMap;
  static List<Map<int, String>> _createListMapFromText(String text) {
    List<String> lines = text.split('\n');

    List<Map<int, String>> listMap = lines.map((line) {
      Map<int, String> map = {};
      return map;
    }).toList();
    return listMap;
  }

  String generateString(int rowLength, Map<int, String> rowMap) {
    List<Map<int, String?>> sortedChords = [];

    rowMap.forEach((index, subword) {
      sortedChords.add({index: subword});
    });
    sortedChords.sort((a, b) => a.keys.first.compareTo(b.keys.first));

    StringBuffer result = StringBuffer();
    int lastIndex = 0;

    for (var chordInfo in sortedChords) {
      int index = chordInfo.keys.first;
      String chord = chordInfo[index] ?? '';

      result.write(' ' * (index - lastIndex));
      result.write(chord);

      lastIndex = index + chord.length;
    }
    // add trailing spaces if needed
    result.write(' ' * (rowLength - lastIndex));
    return result.toString();
  }

  @override
  State<AnnotateScreen> createState() => _AnnotateScreenState();
}

class _AnnotateScreenState extends State<AnnotateScreen> {
  void annotateChar(lineIndex, charIndex, chord) {
    setState(() {
      if (widget.listMap[lineIndex][charIndex] == chord) {
        // if the same chord is selected again, remove it
        widget.listMap[lineIndex].remove(charIndex);
        return;
      }
      widget.listMap[lineIndex][charIndex] = chord;
    });
    // debug print
    // print("new chordAnnotations map states: ");
    // for (Map<int, String> rowMap in widget.listMap) {
    //   print(rowMap);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy lyrics for testing
    final String lyrics = widget.text;

    int lineIndex = 0;
    List<Widget> textList = [];
    for (final line in lyrics.split("\n")) {
      textList.add(buildAnnotationLine(lineIndex, line.length));
      textList.add(buildTappableLyricsLine(line, lineIndex, context));
      lineIndex++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Annotation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textList,
          ),
        ),
      ),
    );
  }

  Widget buildAnnotationLine(int lineIndex, int lineLength) {
    return Text(
      //widget.listMap[lineIndex].toString(),
      widget.generateString(lineLength, widget.listMap[lineIndex]),
      style: const TextStyle(
        backgroundColor: Colors.red,
        fontSize: 22,
      ), // TODO: add monospace font family
    );
  }

  Widget buildTappableLyricsLine(
      String lyrics, int lineIndex, BuildContext context) {
    List<TextSpan> spans = [];

    for (int i = 0; i < lyrics.length; i++) {
      String character = lyrics[i];
      spans.add(
        TextSpan(
          text: character,
          style: const TextStyle(fontSize: 22.0, color: Colors.white),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Show the Chord Modal or handle the tap
              showModalBottomSheet(
                context: context,
                builder: (context) =>
                    ChordModal(character, lineIndex, i, annotateChar),
              );
            },
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}

class ChordModal extends StatelessWidget {
  final String character;
  final int lineIndex;
  final int charIndex;
  final Function annotateChar;

  const ChordModal(
      this.character, this.lineIndex, this.charIndex, this.annotateChar);

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

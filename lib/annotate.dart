import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:guitar_app/chord.dart';

class Annotate extends StatefulWidget {
  Annotate(
      {super.key,
      required this.text,
      required this.nextScreenCallback,
      required this.saveAnnotations});
  //: listMap = _createListMapFromText(text);
  final String text;
  final Function(bool) nextScreenCallback;
  final Function(List<Map<int, String>>) saveAnnotations;

  List<Map<int, String>>? listMap = null;
  List<Map<int, String>> _createListMapFromText(String text) {
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
  State<Annotate> createState() => _AnnotateState();
}

class _AnnotateState extends State<Annotate> {
  void annotateChar(lineIndex, charIndex, chord) {
    setState(() {
      if (widget.listMap != null &&
          widget.listMap![lineIndex][charIndex] == chord) {
        // if the same chord is selected again, remove it
        widget.listMap![lineIndex].remove(charIndex);
        return;
      }
      widget.listMap![lineIndex][charIndex] = chord;
    });
    // debug print
    // print("new chordAnnotations map states: ");
    // for (Map<int, String> rowMap in widget.listMap) {
    //   print(rowMap);
    // }
  }

  @override
  void initState() {
    if (widget.listMap == null || widget.listMap!.isEmpty) {
      widget.listMap = widget._createListMapFromText(widget.text);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int lineIndex = 0;
    List<Widget> textList = [];
    for (final line in widget.text.split("\n")) {
      textList.add(buildAnnotationLine(lineIndex, line.length));
      textList.add(buildTappableLyricsLine(line, lineIndex, context));
      lineIndex++;
    }
    // add button with callbacks at the end of the Widget list
    textList.add(ElevatedButton(
        onPressed: () {
          widget.nextScreenCallback(true);
          widget.saveAnnotations(widget.listMap!);
        },
        child: const Text("Proceed to add song metadata")));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textList),
    );
  }

  Widget buildAnnotationLine(int lineIndex, int lineLength) {
    return Text(
      //widget.listMap[lineIndex].toString(),
      widget.listMap != null
          ? widget.generateString(lineLength, widget.listMap![lineIndex])
          : "",
      style: const TextStyle(
          backgroundColor: Colors.red, fontSize: 22, fontFamily: "Monospace"),
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
          style: const TextStyle(
              fontSize: 22.0, color: Colors.white, fontFamily: "Monospace"),
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

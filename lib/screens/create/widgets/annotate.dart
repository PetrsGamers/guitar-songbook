import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'chord_modal.dart';

class Annotate extends StatefulWidget {
  const Annotate(
      {super.key,
      required this.text,
      required this.nextScreenCallback,
      required this.saveAnnotations});
  final String text;
  final Function(bool) nextScreenCallback;
  final Function(List<Map<int, String>>) saveAnnotations;

  @override
  State<Annotate> createState() => _AnnotateState();
}

class _AnnotateState extends State<Annotate> {
  List<Map<int, String>> listMap = [];

  List<Map<int, String>> _createListMapFromText(String text) {
    List<String> lines = text.split('\n');

    List<Map<int, String>> listMap = lines.map((line) {
      Map<int, String> map = {};
      return map;
    }).toList();
    return listMap;
  }

  String _generateString(int rowLength, Map<int, String> rowMap) {
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

  // todo: dát metody private
  void annotateChar(lineIndex, charIndex, chord) {
    setState(() {
      if (listMap.isNotEmpty && listMap[lineIndex][charIndex] == chord) {
        // if the same chord is selected again, remove it
        listMap[lineIndex].remove(charIndex);
        return;
      }
      listMap[lineIndex][charIndex] = chord;
    });
  }

  @override
  void initState() {
    super.initState();
    if (listMap.isEmpty) {
      listMap = _createListMapFromText(widget.text);
    }
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: textList),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 46),
            child: ElevatedButton(
                onPressed: () {
                  // no need to check if user has provided some anntations,
                  // afterall it's a music book, it is possible to insert
                  // just lyrics
                  widget.nextScreenCallback(true);
                  widget.saveAnnotations(listMap);
                },
                child: const Text("Proceed to add song metadata")),
          )
        ],
      ),
    );
  }

  Widget buildAnnotationLine(int lineIndex, int lineLength) {
    return Text(
      listMap.isNotEmpty ? _generateString(lineLength, listMap[lineIndex]) : "",
      style: const TextStyle(fontSize: 20, fontFamily: "Monospace"),
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
              fontSize: 20.0, color: Colors.white, fontFamily: "Monospace"),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ChordModal(
                    character: character,
                    lineIndex: lineIndex,
                    charIndex: i,
                    annotateChar: annotateChar),
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

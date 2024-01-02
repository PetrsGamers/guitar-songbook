import 'package:flutter/material.dart';
import 'package:guitar_app/chord.dart';

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

  String formatTransposition() {
    if (transposition > 0) {
      return "+${transposition.toString()}";
    }
    return transposition.toString();
  }

  String transposeSong(int semitones, List<String> chordsAndText) {
    final String chordString = chordsAndText[0];
    if (semitones == 0) {
      return chordString;
    }
    String result = "";
    for (String chord in chordString.split(" ")) {
      Chord ch = Chord(chord);
      ch.transpose(semitones);
      result += "$ch ";
    }
    return result;
    // convert to objects
    // transpose each cord object
    // return list of transposed chords
  }

  @override
  Widget build(BuildContext context) {
    final linesString =
        widget.text.replaceAll("\\n", "\n"); // set right newlines
    List<String> lines = linesString.split('\n'); //split by new lines
    List<Widget> textWidgets = []; // Store widgets to display
    textWidgets.add(Row(
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                transposition =
                    (transposition - 1) % DetailSongView.circleOfFifthsLen;
                songKeyChord.transpose(-1);
              });
            },
            child: const Icon(Icons.arrow_downward)),
        Text(songKeyChord.toString()),
        const Text(
            "  "), // TODO: temp solution, replace with padding and proper axis alignment
        Text(formatTransposition()),
        ElevatedButton(
            onPressed: () {
              setState(() {
                transposition =
                    (transposition + 1) % DetailSongView.circleOfFifthsLen;
                songKeyChord.transpose(1);
              });
            },
            child: const Icon(Icons.arrow_upward))
      ],
    ));
    for (var line in lines) {
      final text1 = separateText(line);
      final transposedChords = transposeSong(transposition, text1);
      final distance = charDistancesBetweenBrackets(line);
      final textik = addSpacesCountWithDistances(transposedChords, distance);
      textWidgets.add(
        Text(
          textik,
          style: TextStyle(fontFamily: "Monospace"),
        ),
      );
      textWidgets.add(
        Text(
          text1[1],
          style: TextStyle(fontFamily: "Monospace"),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textWidgets.isNotEmpty ? textWidgets : [Text("")],
    );
  }

  // function to separate text into two parts
  List<String> separateText(String inputText) {
    RegExp exp =
        RegExp(r'\[(.*?)\]'); // Regular expression to find text within brackets
    Iterable<Match> matches = exp.allMatches(inputText);

    String textInBrackets = '';
    String textOutsideBrackets = '';

    for (Match match in matches) {
      textInBrackets += '${match.group(1)} ';
    }

    textOutsideBrackets = inputText.replaceAllMapped(exp, (match) => '');
    return [textInBrackets.trim(), textOutsideBrackets.trim()];
  }

  // function to count the distance between two chords
  List<int> charDistancesBetweenBrackets(String text) {
    List<int> distances = [];
    int start = -1;
    if (text.indexOf('[') != 0) {
      distances.add(text.indexOf('['));
    } else {
      distances.add(0);
    }
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ']') {
        start = i;
      } else if (text[i] == '[' && start != -1) {
        distances.add(i - start - 2);
        start = -1;
      }
    }
    print(distances);
    return distances;
  }

  // function to add spaces to space it evenly above the text
  String addSpacesCountWithDistances(String input, List<int> distances) {
    List<String> chars = input.split(' ');
    String result = '';
    int index = 0;
    int prevcharlenght = 1;
    for (String char in chars) {
      if (char.isNotEmpty) {
        if (prevcharlenght > 1) {
          result += '${' ' * (distances[index] - prevcharlenght + 1)}' + char;
          index = (index + 1) % distances.length;
        } else {
          result += '${' ' * (distances[index])}' + char;
          index = (index + 1) % distances.length;
        }
        prevcharlenght = char.length;
      }
    }
    return result;
  }
}

import 'package:flutter/material.dart';

class DetailSongView extends StatelessWidget {
  const DetailSongView({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final linesstring = text.replaceAll("\\n", "\n"); // set right newlines
    List<String> lines = linesstring.split('\n'); //split by new lines
    List<Widget> textWidgets = []; // Store widgets to display
    print(lines);
    for (var line in lines) {
      final text1 = separateText(line);
      final distance = charDistancesBetweenBrackets(line);
      final textik = addSpacesCountWithDistances(text1[0], distance);
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
    for (String char in chars) {
      if (char.isNotEmpty) {
        if (char.length > 1) {
          result += char + '${' ' * (distances[index] - char.length + 1)}';
          index = (index + 1) % distances.length;
        } else {
          result += char + '${' ' * distances[index]}';
          index = (index + 1) % distances.length;
        }
      }
    }
    return result.trim();
  }
}

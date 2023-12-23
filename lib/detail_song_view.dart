import 'package:flutter/material.dart';

class DetailSongView extends StatelessWidget {
  const DetailSongView({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final text1 = separateText(text);
    final distance = charDistancesBetweenBrackets(text);
    final textik = addSpacesCountWithDistances(text1[0], distance);
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start

        children: [
          Text(
            textik,
            style: TextStyle(fontFamily: "Monospace"),
          ),
          Text(
            text1[1],
            style: TextStyle(fontFamily: "Monospace"),
          )
        ]);
  }

  List<String> separateText(String inputText) {
    RegExp exp =
        RegExp(r'\[(.*?)\]'); // Regular expression to find text within brackets
    Iterable<Match> matches = exp.allMatches(inputText);

    String textInBrackets = '';
    String textOutsideBrackets = '';

    for (Match match in matches) {
      textInBrackets += '${match.group(1)} ';
    }

    textOutsideBrackets = inputText.replaceAllMapped(
        exp, (match) => ''); // Remove text within brackets
    print(textInBrackets.trim());
    print(textOutsideBrackets.trim());
    return [textInBrackets.trim(), textOutsideBrackets.trim()];
  }

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

  String addSpacesCountWithDistances(String input, List<int> distances) {
    List<String> chars = input.split(' ');
    String result = '';
    int index = 0;
    print("inpout " + '${input}');
    print(distances);
    for (String char in chars) {
      if (char.isNotEmpty) {
        result += char + '${' ' * distances[index]}';
        index = (index + 1) % distances.length;
      }
    }
    print(result);
    return result.trim(); // Trim to remove extra space at the end
  }
}

import 'package:flutter/material.dart';
import 'package:guitar_app/songs_class.dart';

class DetailSongView extends StatelessWidget {
  const DetailSongView({
    super.key,
    required this.text,
  });

  final text;

  @override
  Widget build(BuildContext context) {
    final text1 = separateText(text);
    return Text(text1[1]);
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

    return [textInBrackets.trim(), textOutsideBrackets.trim()];
  }
}

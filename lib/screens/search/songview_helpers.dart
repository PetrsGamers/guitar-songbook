import 'package:guitar_app/entities/chord.dart';

String transposeSong(int semitones, List<String> chordsAndText) {
  final String chordString = chordsAndText[0];
  if (semitones == 0) {
    return chordString;
  }
  String result = "";
  for (String chord in chordString.split(" ")) {
    if (!RegExp(r'^[ABCDEFGH]#?m?7?$').hasMatch(chord)) {
      // if a proper chord isn't parsed, ignore it
      print("ignoruju $chord");
      continue;
    }
    Chord ch = Chord(chord);
    ch.transpose(semitones);
    result += "$ch ";
  }
  return result;
}

// function to separate text into two parts
List<String> separateText(String inputText) {
  RegExp exp =
      RegExp(r'{(.*?)\}'); // Regular expression to find text within brackets
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
  if (text.indexOf('{') != 0) {
    distances.add(text.indexOf('}') - 2);
  } else {
    distances.add(0);
  }
  for (int i = 0; i < text.length; i++) {
    if (text[i] == '}') {
      start = i;
    } else if (text[i] == '{' && start != -1) {
      distances.add(i - start - 2);
      start = -1;
    }
  }
  return distances;
}

// function to add spaces to space it evenly above the text
String addSpacesCountWithDistances(String input, List<int> distances) {
  List<String> chars = input.split(' ');
  String result = '';
  int index = 0;
  int prevCharLen = 1;
  for (String char in chars) {
    if (char.isNotEmpty) {
      if (prevCharLen > 1) {
        result += ' ' * (distances[index] - prevCharLen + 1) + char;
        index = (index + 1) % distances.length;
      } else {
        result += ' ' * (distances[index]) + char;
        index = (index + 1) % distances.length;
      }
      prevCharLen = char.length;
    }
  }
  return result;
}

String formatTransposition(int transposition) {
  if (transposition > 0) {
    return "+${transposition.toString()}";
  }
  return transposition.toString();
}

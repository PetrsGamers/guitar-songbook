import 'package:flutter/services.dart';

String getFileExtension(String filename) {
  return filename.split(".").last;
}

String getFileExtensionFromMime(String? mimeType) {
  if (mimeType == null) {
    return "";
  }
  return mimeType.split("/").last;
}

class LineLengthLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  LineLengthLimitingTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Split the new value into lines
    final lines = newValue.text.split('\n');

    // Limit the length of each line
    final limitedLines = lines.map((line) {
      if (line.length > maxLength) {
        return line.substring(0, maxLength);
      }
      return line;
    });

    final limitedText = limitedLines.join('\n');
    return TextEditingValue(text: limitedText);
  }
}

String serializeLyrics(String text, List<Map<int, String>> annotationsList) {
  // clean curly braces from the text (sanity)
  String cleanText = text.replaceAll(RegExp(r'[{}]', multiLine: true), '');
  List<String> lines = cleanText.split('\n');

  for (int i = 0; i < lines.length; i++) {
    if (i < annotationsList.length) {
      Map<int, String> annotations = annotationsList[i];
      List<int> sortedIndices = annotations.keys.toList()..sort();

      for (int j = sortedIndices.length - 1; j >= 0; j--) {
        int index = sortedIndices[j];
        String chord = annotations[index]!;
        lines[i] =
            '${lines[i].substring(0, index)}{$chord}${lines[i].substring(index)}';
      }
    }
  }
  return lines.join('\n');
}

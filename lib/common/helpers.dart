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

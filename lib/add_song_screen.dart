import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSongScreen extends StatelessWidget {
  const AddSongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create song'),
      ),
      body: Center(
          child: Column(children: [
        const Text("Insert the song text:"),
        Expanded(
            child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[/\\\[\]]')),
            LineLengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            hintText: "Insert text here",
          ),
          scrollPadding: EdgeInsets.all(20.0),
          keyboardType: TextInputType.multiline,
          autofocus: true,
          minLines: 4,
          maxLines: null,
        )),
        ElevatedButton(onPressed: null, child: Text("Proceed to annotate text"))
      ])),
    );
  }
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

    // Join the lines back together with newline characters
    final limitedText = limitedLines.join('\n');

    return TextEditingValue(text: limitedText);
  }
}

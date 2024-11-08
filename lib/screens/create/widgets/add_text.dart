import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_app/common/helpers.dart';

class AddText extends StatefulWidget {
  const AddText(
      {super.key,
      required this.text,
      required this.nextScreenCallback,
      required this.saveText});

  final String text;
  final Function(bool) nextScreenCallback;
  final Function(String) saveText;

  @override
  State<AddText> createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: SizedBox(
        width: 400,
        child: Column(children: [
          Expanded(
              child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[/\\{\}]')),
              LineLengthLimitingTextInputFormatter(40),
            ],
            controller: _textController,
            decoration: const InputDecoration(
              hintText: "Write down the song lyrics here",
            ),
            scrollPadding: const EdgeInsets.all(20.0),
            keyboardType: TextInputType.multiline,
            autofocus: true,
            minLines: 4,
            maxLines: null,
          )),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 46),
            child: ElevatedButton(
                onPressed: () {
                  if (_textController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Provide some text")));
                    return;
                  }
                  widget.saveText(_textController.text);
                  widget.nextScreenCallback(true);
                },
                child: const Text("Proceed to annotate lyrics with chords")),
          )
        ]),
      ),
    ));
  }
}

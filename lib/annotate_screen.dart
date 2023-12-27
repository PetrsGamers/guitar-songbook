import 'package:flutter/material.dart';

// class AnnotateScreen extends StatelessWidget {
//   const AnnotateScreen({Key? key}) : super(key: key);
//
//   final String song_text = """I heard there was a secret chord
//   that David played and it pleased the lord
//   But you don't really care for music, do ya?""";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create song'),
//       ),
//       body: Center(
//         child: Column(children: [
//           const Text("Tap text to annotate with chords:"),
//           Text(song_text)
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';

class AnnotateScreen extends StatelessWidget {
  const AnnotateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy lyrics for testing
    final String lyrics = """I heard there was a secret chord
that David played and it pleased the lord
But you don't really care for music, do ya?""";

    return Scaffold(
      appBar: AppBar(
        title: Text('Chord Annotation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildAnnotatedText(lyrics, context),
        ),
      ),
    );
  }

  Widget buildAnnotatedText(String lyrics, BuildContext context) {
    List<TextSpan> spans = [];

    for (int i = 0; i < lyrics.length; i++) {
      String character = lyrics[i];
      spans.add(
        TextSpan(
          text: character,
          style: TextStyle(fontSize: 24.0, color: Colors.white),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Show the Chord Modal or handle the tap
              showModalBottomSheet(
                context: context,
                builder: (context) => ChordModal(character, i),
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

class ChordModal extends StatelessWidget {
  final String character;
  final int charIndex;

  ChordModal(this.character, this.charIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Select Chord for "$character", index: $charIndex:'),
          ElevatedButton(
            onPressed: () {
              // Handle chord selection
              Navigator.pop(context);
            },
            child: Text('C'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle chord selection
              Navigator.pop(context);
            },
            child: Text('D'),
          ),
          // Add more chord buttons as needed
        ],
      ),
    );
  }
}

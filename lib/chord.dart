class Chord {
  static List<String> circleOfFifths = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "H"
  ];

  final String chord;
  bool isMinor = false;
  bool isSeventh = false;
  String? baseChord;
  Chord(this.chord) {
    if (chord.contains("m")) {
      isMinor = true;
    }
    if (chord.contains("7")) {
      isSeventh = true;
    }
    // strip the information since it is already saved in booleans
    baseChord = chord.replaceAll(RegExp(r'[m7]'), '');
  }

  void transpose(int semitones) {
    if (baseChord != null) {
      final int initialIndex = circleOfFifths.indexOf(baseChord![0]);
      final int transposedIndex =
          (initialIndex + semitones) % circleOfFifths.length;
      baseChord = circleOfFifths[transposedIndex];
    }
  }

  @override
  String toString() {
    return '$baseChord${isMinor ? "m" : ""}${isSeventh ? "7" : ""}';
  }
}

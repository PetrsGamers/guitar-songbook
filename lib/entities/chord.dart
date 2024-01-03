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
  static List<String> songKeys = [
    "C",
    "Cm",
    "C#",
    "C#m",
    "D",
    "Dm",
    "D#",
    "D#m",
    "E",
    "Em",
    "F",
    "Fm",
    "F#",
    "F#m",
    "G",
    "Gm",
    "G#",
    "G#m",
    "A",
    "Am",
    "A#",
    "A#m",
    "H",
    "Hm"
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
      final int initialIndex = circleOfFifths.indexOf(baseChord!);
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

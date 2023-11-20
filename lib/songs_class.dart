class Song {
  String author;
  String text;
  String name;

  Song({required this.author, required this.text, required this.name});

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      author: map['author'] ?? '', // Provide default value if null
      text: map['text'] ?? '', // Provide default value if null
      name: map['name'] ?? '', // Provide default value if null
    );
  }
}

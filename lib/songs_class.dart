class Song {
  String author;
  String text;
  String name;
  String id;

  Song(
      {required this.author,
      required this.text,
      required this.name,
      required this.id});

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      author: map['author'] ?? '', // Provide default value if null
      text: map['text'] ?? '', // Provide default value if null
      name: map['name'] ?? '',
      id: map['id'] ?? '', // Provide default value if null
    );
  }
}

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

  factory Song.fromMap(String id, Map<String, dynamic> map) {
    return Song(
      author: map['author'] ?? '',
      text: map['text'] ?? '',
      name: map['name'] ?? '',
      id: id,
    );
  }
}

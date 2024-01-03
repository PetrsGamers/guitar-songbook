class Song {
  String author;
  String userId;
  String text;
  String name;
  String bpm;
  String year;
  String key;
  String id;

  double? rating;

  Song(
      {required this.author,
      required this.text,
      required this.name,
      required this.key,
      required this.userId,
      required this.bpm,
      required this.year,
      required this.id});

  factory Song.fromMap(String id, Map<String, dynamic> map) {
    return Song(
      author: map['author'] ?? '',
      text: map['text'] ?? '',
      name: map['name'] ?? '',
      key: map['key'] ?? '',
      userId: map['userId'] ?? '',
      bpm: map['bpm'] ?? '',
      year: map['year'] ?? '',
      id: id,
    );
  }
}

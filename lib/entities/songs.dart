class Song {
  final String author;
  final String userId;
  final String text;
  final String name;
  final String bpm;
  final String year;
  final String key;
  final String id;

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

class Rating {
  final String author;
  double number;
  final String id;

  Rating({required this.author, required this.number, required this.id});

  factory Rating.fromMap(String id, Map<String, dynamic> map) {
    return Rating(
      author: map['author'] ?? '',
      number: map['number'] ?? '',
      id: id,
    );
  }
}

class AppUser {
  String id;
  String name;
  String bio;
  String picture;
  String email;

  AppUser(
      {required this.id,
      required this.name,
      required this.bio,
      required this.picture,
      required this.email});

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      picture: map['picture'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

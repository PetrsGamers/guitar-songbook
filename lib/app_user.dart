class AppUser {
  String name;
  String bio;
  String picture;
  String email;

  AppUser(
      {required this.name,
      required this.bio,
      required this.picture,
      required this.email});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      picture: map['picture'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

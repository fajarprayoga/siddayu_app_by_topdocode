class User {
  final String id;
  final String name;
  final String email;
  final role;
  final position;
  final String? profile_picture;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.position,
    required this.profile_picture,
  });

  // Factory method untuk membuat instance User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        position: json['position'],
        profile_picture: json['profile_picture']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'profile_picture': profile_picture,
        'position': position,
      };
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? position;
  final String? profilePicture;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.position,
    this.profilePicture,
  });

  // Factory method untuk membuat instance User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        position: json['position'],
        profilePicture: json['profile_picture']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'profile_picture': profilePicture,
        'position': position,
      };
}

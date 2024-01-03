class Auth {
  final String id;
  final String name;
  final String email;
  final role;
  final position;
  final String? created_at;
  final String? updated_at;

  Auth({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.position,
    required this.created_at,
    required this.updated_at,
  });

  // Factory method untuk membuat instance User dari JSON
  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        position: json['position'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'position': position,
        'created_at': created_at,
        'updated_at': updated_at,
      };
}

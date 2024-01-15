import 'position.dart';
import 'role.dart';

class User {
  String? id;
  String? name;
  String? email;
  Role? role;
  Position? position;
  dynamic profilePicture;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.position,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        role: json['role'] == null
            ? null
            : Role.fromJson(json['role'] as Map<String, dynamic>),
        position: json['position'] == null
            ? null
            : Position.fromJson(json['position'] as Map<String, dynamic>),
        profilePicture: json['profile_picture'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role?.toJson(),
        'position': position?.toJson(),
        'profile_picture': profilePicture,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

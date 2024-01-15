class Role {
  String? id;
  String? name;
  String? code;
  DateTime? createdAt;
  DateTime? updatedAt;

  Role({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] as String?,
        name: json['name'] as String?,
        code: json['code'] as String?,
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
        'code': code,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

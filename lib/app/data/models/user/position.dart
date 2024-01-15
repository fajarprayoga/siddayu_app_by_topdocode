class Position {
  String? id;
  String? name;
  String? code;
  dynamic parentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Position({
    this.id,
    this.name,
    this.code,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        id: json['id'] as String?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        parentId: json['parent_id'] as dynamic,
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
        'parent_id': parentId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

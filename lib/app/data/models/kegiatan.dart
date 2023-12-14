class Kegiatan {
  final int? id;
  final String todo;
  final bool completed;
  final int userId;

  Kegiatan({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  // Factory method untuk membuat instance User dari JSON
  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'todo': todo,
        'completed': completed,
        'userId': userId,
      };
}

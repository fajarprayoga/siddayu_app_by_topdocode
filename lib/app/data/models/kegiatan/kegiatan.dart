import 'sub_activity.dart';

class Kegiatan {
  String? id;
  String? activityNumber;
  DateTime? activityDate;
  String? name;
  String? description;
  dynamic location;
  String? status;
  dynamic totalBudget;
  List<SubActivity>? subActivities;
  List<dynamic>? documents;
  int? progress;
  String? createdBy;

  Kegiatan({
    this.id,
    this.activityNumber,
    this.activityDate,
    this.name,
    this.description,
    this.location,
    this.status,
    this.totalBudget,
    this.subActivities,
    this.documents,
    this.progress,
    this.createdBy,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) => Kegiatan(
        id: json['id'] as String?,
        activityNumber: json['activity_number'] as String?,
        activityDate: json['activity_date'] == null
            ? null
            : DateTime.parse(json['activity_date'] as String),
        name: json['name'] as String?,
        description: json['description'] as String?,
        location: json['location'] as dynamic,
        status: json['status'] as String?,
        totalBudget: json['total_budget'] as dynamic,
        subActivities: (json['sub_activities'] as List<dynamic>?)
            ?.map((e) => SubActivity.fromJson(e as Map<String, dynamic>))
            .toList(),
        documents: json['documents'] as List<dynamic>?,
        progress: json['progress'] as int?,
        createdBy: json['created_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'activity_number': activityNumber,
        'activity_date': activityDate?.toIso8601String(),
        'name': name,
        'description': description,
        'location': location,
        'status': status,
        'total_budget': totalBudget,
        'sub_activities': subActivities?.map((e) => e.toJson()).toList(),
        'documents': documents,
        'progress': progress,
        'created_by': createdBy,
      };
}

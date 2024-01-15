import 'package:flutter/material.dart';

class Kegiatan {
  final String id;
  final String activityNumber;
  final DateTime activityDate;
  final String name;
  final String description;
  // final String location;
  final String status;
  final int? totalBudget;
  final List subActivities;
  // final List<SubActivity> subActivities;
  // final List<Document> documents;
  // final List documents;
  final double progress;

  Kegiatan({
    required this.id,
    required this.activityNumber,
    required this.activityDate,
    required this.name,
    required this.description,
    // required this.location,
    required this.status,
    required this.totalBudget,
    required this.subActivities,
    // required this.documents,
    required this.progress,
  });

  // Factory method to create an instance of Kegiatan from JSON
  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      activityNumber: json['activity_number'],
      activityDate: DateTime.parse(json['activity_date']),
      name: json['name'],
      description: json['description'],
      // location: json['location'],
      status: json['status'] ?? 'progress',
      totalBudget: json['total_budget'] == null ? 0 : json['total_budget'],
      subActivities: (json['sub_activities'] as List<dynamic>?)
              ?.map((subActivity) => SubActivity.fromJson(subActivity))
              .toList() ??
          [],
      // documents: (json['documents'] as List)
      //     .map((document) => Document.fromJson(document))
      //     .toList(),
      progress: json['progress'] == null ? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'activity_number': activityNumber,
        'activity_date': activityDate.toIso8601String(),
        'name': name,
        'description': description,
        // 'location': location,
        'status': status,
        'total_budget': totalBudget,
        'sub_activities':
            subActivities.map((subActivity) => subActivity.toJson()).toList(),
        //     ? subActivities.map((subActivity) => subActivity.toJson()).toList()
        //     : [{}].toList(),
        // 'documents': documents.map((document) => document.toJson()).toList(),
        'progress': progress,
      };
}

class SubActivity {
  final String name;
  final int totalBudget;

  SubActivity({
    required this.name,
    required this.totalBudget,
  });

  factory SubActivity.fromJson(Map<String, dynamic> json) {
    return SubActivity(
      name: json['name'],
      totalBudget: json['total_budget'] != null
          ? int.parse(json['total_budget'].toString())
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'total_budget': totalBudget,
      };
}

class Document {
  final String id;
  final String title;
  final String url;
  final String type;

  Document({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'type': type,
      };
}

class SubActivity2 {
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  SubActivity2({required this.nameController, required this.totalController});
}

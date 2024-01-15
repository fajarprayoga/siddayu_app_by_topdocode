class SubActivity {
  String? name;
  int? totalBudget;

  SubActivity({this.name, this.totalBudget});

  factory SubActivity.fromJson(Map<String, dynamic> json) => SubActivity(
        name: json['name'] as String?,
        totalBudget: json['total_budget'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'total_budget': totalBudget,
      };
}

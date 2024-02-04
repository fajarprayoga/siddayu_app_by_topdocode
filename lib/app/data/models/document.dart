class Document {
  String? id;
  String? title;
  String? url;
  String? type;

  Document({this.id, this.title, this.url, this.type});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'] as String?,
        title: json['title'] as String?,
        url: json['url'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'type': type,
      };
}

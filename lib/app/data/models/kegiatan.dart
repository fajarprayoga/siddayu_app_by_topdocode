class Kegiatan {
  final int id;
  final List<Object> sk;
  final List<Object> berita_acara;
  final List<Object> pbj;
  final List<List<Object>> amprahan;

  Kegiatan({
    required this.id,
    required this.sk,
    required this.berita_acara,
    required this.pbj,
    required this.amprahan,
  });

  // Factory method untuk membuat instance User dari JSON
  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
        id: json['id'],
        sk: json['sk'],
        berita_acara: json['berita_acara'],
        pbj: json['pbj'],
        amprahan: json['amprahan']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sk': sk,
        'berita_acara': berita_acara,
        'pbj': pbj,
        'amprahan': amprahan,
      };
}

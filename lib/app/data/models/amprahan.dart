import 'dart:io';

import 'package:flutter/material.dart';

class Amprahan {
  String? id;
  TextEditingController noAmprahan;
  List<File> fileDokumentasiKegiatan;
  TextEditingController totalRealisasiAnggaran;
  TextEditingController sumberDana;
  List<File> fileDokumentasiPajak;
  List<File> fileBuktiPajak;
  TextEditingController amprahanDate;
  TextEditingController disbuermentDate;
  bool isPajak;

  Amprahan({
    this.id,
    required this.noAmprahan,
    required this.fileDokumentasiKegiatan,
    required this.totalRealisasiAnggaran,
    required this.sumberDana,
    required this.fileDokumentasiPajak,
    required this.fileBuktiPajak,
    required this.amprahanDate,
    required this.disbuermentDate,
    required this.isPajak,
  });
}

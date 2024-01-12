import 'dart:io';

import 'package:flutter/material.dart';

class Amprahan {
  TextEditingController noAmprahan;
  List<File> fileDokumentasiKegiatan;
  TextEditingController totalRealisasiAnggaran;
  TextEditingController sumberDana;
  List<File> fileDokumentasiPajak;

  Amprahan({
    required this.noAmprahan,
    required this.fileDokumentasiKegiatan,
    required this.totalRealisasiAnggaran,
    required this.sumberDana,
    required this.fileDokumentasiPajak,
  });
}

import 'dart:io';

import 'package:flutter/material.dart';

class Amprahan {
  String? id;
  TextEditingController noAmprahan;
  List<File> fileDokumentasiKegiatan;
  List<String> fileDokumentasiKegiatanName;
  List<File> fileDokumentasiAmprahan;
  List<String> fileDokumentasiAmprahanName;
  TextEditingController totalRealisasiAnggaran;
  TextEditingController sumberDana;
  List<File> fileDokumentasiPajak;
  List<String> fileDokumentasiPajakName;
  List<File> fileBuktiPajak;
  List<String> fileBuktiPajakName;
  TextEditingController amprahanDate;
  TextEditingController disbuermentDate;
  bool isPajak;

  Amprahan({
    this.id,
    required this.noAmprahan,
    required this.fileDokumentasiKegiatan,
    required this.fileDokumentasiAmprahan,
    required this.fileDokumentasiKegiatanName,
    required this.fileDokumentasiAmprahan,
    required this.fileDokumentasiAmprahanName,
    required this.totalRealisasiAnggaran,
    required this.sumberDana,
    required this.fileDokumentasiPajak,
    required this.fileDokumentasiPajakName,
    required this.fileBuktiPajak,
    required this.fileBuktiPajakName,
    required this.amprahanDate,
    required this.disbuermentDate,
    required this.isPajak,
  });
}

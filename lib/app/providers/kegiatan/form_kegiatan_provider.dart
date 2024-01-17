import 'dart:io';

import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart' hide MultipartFile;
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import '../../data/models/amprahan.dart';

class FormKegiatanState {
  final List<File> fileSK;
  final List<File> fileBeritaAcara;
  final List<File> fileOption;
  final List<Amprahan> amprahans;

  FormKegiatanState(
      {this.fileSK = const [], this.fileBeritaAcara = const [], this.fileOption = const [], this.amprahans = const []});

  FormKegiatanState copyWith(
      {List<File>? fileSK, List<File>? fileBeritaAcara, List<File>? fileOption, List<Amprahan>? amprahans}) {
    return FormKegiatanState(
        fileSK: fileSK ?? this.fileSK,
        fileBeritaAcara: fileBeritaAcara ?? this.fileBeritaAcara,
        fileOption: fileOption ?? this.fileOption,
        amprahans: amprahans ?? this.amprahans);
  }
}

class FormKegiatanNotifier extends StateNotifier<FormKegiatanState> with Apis {
  final Kegiatan kegiatan;
  FormKegiatanNotifier(this.kegiatan) : super(FormKegiatanState());

  Map<String, dynamic> tempFiles = {'sk': [], 'operational_report': [], 'other': []};

  Future<bool> uploadFiles(String type, List<File> files) async {
    try {
      final mfiles = await fileToMultipart(files);

      Map<String, dynamic> payload = {
        'type': 'sk',
        'activity_id': kegiatan.id,
      };

      for (var i = 0; i < mfiles.length; i++) {
        payload['files[$i]'] = mfiles[i];
      }

      final res = await kegiatanApi.uploadDoc(payload);

      if (!res.status) {
        LzToast.error(res.message ?? 'Gagal mengunggah file');
      }

      tempFiles[type] = [...tempFiles[type], ...res.data['data']];
      logg(tempFiles);

      return res.status;
    } catch (e, s) {
      Errors.check(e, s);
      return false;
    }
  }

  void addFileSK(List<File> files) async {
    LzToast.overlay('Mengunggah file SK');
    final ok = await uploadFiles('sk', files);
    LzToast.dismiss();

    if (ok) {
      state = state.copyWith(fileSK: files);
    }
  }

  void addFileBeritaAcara(List<File> files) async {
    LzToast.overlay('Mengunggah file berita acara');
    final ok = await uploadFiles('operational_report', files);
    LzToast.dismiss();

    if (ok) {
      state = state.copyWith(fileBeritaAcara: files);
    }
  }

  void addFileOption(List<File> files) async {
    LzToast.overlay('Mengunggah file option');
    final ok = await uploadFiles('other', files);
    LzToast.dismiss();

    if (ok) {
      state = state.copyWith(fileOption: files);
    }
  }

  void removeFile(String label, int index) async {
    // find file id
    final id = tempFiles[label][index]['id'];

    if (id == null) {
      return LzToast.warning('File tidak ditemukan');
    }

    try {
      LzToast.overlay('Menghapus file...');
      final res = await kegiatanApi.deleteDoc(id);

      if (res.status) {
        switch (label) {
          case 'sk':
            List<File> files = state.fileSK;
            files.removeAt(index);
            state = state.copyWith(fileSK: files);
            break;
          case 'operational_report':
            List<File> files = state.fileBeritaAcara;
            files.removeAt(index);
            state = state.copyWith(fileBeritaAcara: files);
            break;
          case 'other':
            List<File> files = state.fileOption;
            files.removeAt(index);
            state = state.copyWith(fileOption: files);
            break;
          default:
        }
      }
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }

  void addAmprahan() {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans.add(Amprahan(
        noAmprahan: TextEditingController(),
        fileDokumentasiKegiatan: [],
        totalRealisasiAnggaran: TextEditingController(),
        sumberDana: TextEditingController(),
        fileDokumentasiPajak: [],
        isPajak: false));

    state = state.copyWith(amprahans: amprahans);
  }

  void checkPajak(bool value, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].isPajak = value;
    state = state.copyWith(amprahans: amprahans);
  }

  void removeAmprahan(int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans.removeAt(index);

    state = state.copyWith(amprahans: amprahans);
    LzToast.show('Berhasil menghapus amprahan');
  }

  void addFileDokumentasiKegiatan(List<File> files, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].fileDokumentasiKegiatan = files;

    state = state.copyWith(amprahans: amprahans);
  }

  void addFileDokumentasiPajak(List<File> files, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].fileDokumentasiPajak = files;

    state = state.copyWith(amprahans: amprahans);
  }

  void removeFileAmprahan(String label, int index, int indexAmprahan) {
    List<Amprahan> amprahans = [...state.amprahans];
    switch (label) {
      case 'doc_kegiatan':
        List<File> files = amprahans[indexAmprahan].fileDokumentasiKegiatan;
        files.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiKegiatan = files;
        state = state.copyWith(amprahans: amprahans);
        break;
      case 'pajak':
        List<File> files = amprahans[indexAmprahan].fileDokumentasiPajak;
        files.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiPajak = files;
        state = state.copyWith(amprahans: amprahans);
        break;
      default:
    }
  }

  Future<List<MultipartFile>> fileToMultipart(List<File> files) async {
    List<MultipartFile> multipart = [];
    for (var e in files) {
      final f = await kegiatanApi.toFile(e.path);
      multipart.add(f);
    }

    return multipart;
  }

  Future onSubmit(Kegiatan data) async {
    try {
      final fileSK = await fileToMultipart(state.fileSK);
      final fileBeritaAcara = await fileToMultipart(state.fileBeritaAcara);
      final fileOption = await fileToMultipart(state.fileOption);

      Map<String, dynamic> payload = {
        'file_sk': fileSK,
        'file_berita_acara': fileBeritaAcara,
        'file_option': fileOption,
      };

      if (state.amprahans.isNotEmpty) {
        List<Map<String, dynamic>> amprahans = [];

        for (Amprahan e in state.amprahans) {
          amprahans.add({
            'no_amprahan': e.noAmprahan.text,
            'total_realisasi_anggaran': e.totalRealisasiAnggaran.text,
            'sumber_dana': e.sumberDana.text,
            'file_dokumentasi_kegiatan': await fileToMultipart(e.fileDokumentasiKegiatan),
            'file_dokumentasi_pajak': await fileToMultipart(e.fileDokumentasiPajak),
            'pajak': true
          });
        }

        payload['amprahans'] = amprahans;
      }

      logg(payload);
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}

final formKegiatanProvider =
    StateNotifierProvider.autoDispose.family<FormKegiatanNotifier, FormKegiatanState, Kegiatan>((ref, kegiatan) {
  return FormKegiatanNotifier(kegiatan);
});

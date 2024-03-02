import 'dart:io';

import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart' hide MultipartFile;
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';

import '../../data/models/amprahan.dart';

class FormKegiatanState {
  final List<File> fileSK;
  final List<File> fileSupport;
  final List<File> fileBeritaAcara;
  final List<File> fileSuratPerjanjian;
  final List<File> fileOption;
  final List<Amprahan> amprahans;

  FormKegiatanState(
      {this.fileSK = const [],
      this.fileSupport = const [],
      this.fileBeritaAcara = const [],
      this.fileOption = const [],
      this.amprahans = const [],
      this.fileSuratPerjanjian = const []});

  FormKegiatanState copyWith(
      {List<File>? fileSK,
      List<File>? fileSupport,
      List<File>? fileBeritaAcara,
      List<File>? fileOption,
      List<File>? fileSuratPerjanjian,
      List<Amprahan>? amprahans}) {
    return FormKegiatanState(
        fileSK: fileSK ?? this.fileSK,
        fileSupport: fileSupport ?? this.fileSupport,
        fileBeritaAcara: fileBeritaAcara ?? this.fileBeritaAcara,
        fileSuratPerjanjian: fileSuratPerjanjian ?? this.fileSuratPerjanjian,
        fileOption: fileOption ?? this.fileOption,
        amprahans: amprahans ?? this.amprahans);
  }
}

class FormKegiatanNotifier extends StateNotifier<FormKegiatanState> with Apis {
  final Kegiatan kegiatan;
  FormKegiatanNotifier(this.kegiatan) : super(FormKegiatanState()) {
    Bindings.onRendered(() async {
      getData();
    });
  }

  Future getData() async {
    try {
      LzToast.overlay('Mengambil data amprahan...');

      final res = await kegiatanApi.getAmprahanFiles(kegiatan.id!);
      final data = res.data?['data'] ?? {};

      List documents = data['documents'] ?? [];

      // get and set file sk
      final sk = documents.where((e) => e['type'] == 'sk').toList();
      List<File> fileSK = sk.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileSK: fileSK);
      tempFiles['sk'] = sk;

      // untuk menghapus file dengan support
      final support = documents.where((e) => e['type'] == 'support').toList();
      List<File> fileSupport = support.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileSupport: fileSupport);
      tempFiles['support'] = support; // untuk menghapus file dengan id

      // get and set file support
      final support = documents.where((e) => e['type'] == 'support').toList();
      List<File> fileSupport = support.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileSupport: fileSupport);
      tempFiles['support'] = support; // untuk menghapus file dengan id

      // get and set file berita acara
      final operationalReport = documents.where((e) => e['type'] == 'operational_report').toList();
      List<File> fileBeritaAcara = operationalReport.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileBeritaAcara: fileBeritaAcara);
      tempFiles['operational_report'] = operationalReport; // untuk menghapus file dengan id

      // get and set surat perjanjian kerjasama
      final letterOfAggrement = documents.where((e) => e['type'] == 'letter_of_agreement').toList();
      List<File> fileSuratPerjanjian = letterOfAggrement.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileSuratPerjanjian: fileSuratPerjanjian);
      tempFiles['letter_of_agreement'] = letterOfAggrement; // untuk menghapus file dengan id

      // get and set file option
      final other = documents.where((e) => e['type'] == 'other').toList();
      List<File> fileOption = other.map((e) => File(e['url'])).toList();
      state = state.copyWith(fileOption: fileOption);
      tempFiles['other'] = other; // untuk menghapus file dengan id
      getAmprahan();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  Future getAmprahan() async {
    try {
      final res = await kegiatanApi.getAmprahan(kegiatan.id!);
      final data = res.data?['data'] ?? [];

      List<Amprahan> amprahans = [];
      for (Map<String, dynamic> e in data) {
        List documents = e['documents'] ?? [];

        // get data dokumentasi Kegiatan
        final activityDocumentation = documents.where((e) => e['type'] == 'activity_documentation').toList();
        List<File> fileDokumentasiKegiatan = activityDocumentation.map((e) => File(e['url'])).toList();

        final amprahanDocumentation = documents.where((e) => e['type'] == 'amprahan_documentation').toList();
        List<File> fileDokumentasiAmprahan = amprahanDocumentation.map((e) => File(e['url'])).toList();

        List<String> fileDokumentasiKegiatanName = activityDocumentation.map((e) => e['title']).toList().cast();

        final activityAmprahan = documents.where((e) => e['type'] == 'amprahan_documentation').toList();
        List<File> fileDokumentasiAmprahan = activityAmprahan.map((e) => File(e['url'])).toList();
        List<String> fileDokumentasiAmprahanName = activityAmprahan.map((e) => e['title']).toList().cast();

        // get data dokumentasi pajak
        final taxDocumentation = documents.where((e) => e['type'] == 'tax_documentation').toList();
        List<File> fileDokumentasiPajak = taxDocumentation.map((e) => File(e['url'])).toList();
        List<String> fileDokumentasiPajakName = taxDocumentation.map((e) => e['title']).toList().cast();

        // get data file bukti pajak
        final taxReceipt = documents.where((e) => e['type'] == 'tax_receipt').toList();
        List<File> fileBuktiPajak = taxReceipt.map((e) => File(e['url'])).toList();
        List<String> fileBuktiPajakName = taxReceipt.map((e) => e['title']).toList().cast();

        amprahans.add(Amprahan(
          id: e['id'].toString(),
          noAmprahan: e['amprahan_number'].toString().tec,
          fileDokumentasiKegiatan: fileDokumentasiKegiatan,
          fileDokumentasiAmprahan: fileDokumentasiAmprahan,
          fileDokumentasiKegiatanName: fileDokumentasiKegiatanName,
          fileDokumentasiAmprahan: fileDokumentasiAmprahan,
          fileDokumentasiAmprahanName: fileDokumentasiAmprahanName,
          fileBuktiPajak: fileBuktiPajak,
          fileBuktiPajakName: fileBuktiPajakName,
          totalRealisasiAnggaran: e['total_budget_realisation'].toString().idr(symbol: '').tec,
          sumberDana: e['budget_source'].toString().tec,
          fileDokumentasiPajak: fileDokumentasiPajak,
          fileDokumentasiPajakName: fileDokumentasiPajakName,
          amprahanDate: e['amprahan_date'].toString().tec,
          disbuermentDate: e['disbuerment_date'].toString().tec,
          isPajak: e['pajak'],
        ));
      }

      state = state.copyWith(amprahans: amprahans);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }

  Map<String, List> tempFiles = {
    'sk': [],
    'support': [],
    'operational_report': [],
    'letter_of_agreement': [],
    'other': []
  };

  Future<bool> uploadFiles(String type, List<File> files) async {
    try {
      final mfiles = await fileToMultipart(files);

      Map<String, dynamic> payload = {
        'type': type,
        'activity_id': kegiatan.id,
      };

      for (var i = 0; i < mfiles.length; i++) {
        payload['files[$i]'] = mfiles[i];
      }
      final res = await kegiatanApi.uploadDoc(payload);

      if (!res.status) {
        LzToast.error(res.message ?? 'Gagal mengunggah file');
      }

      tempFiles[type] = [...tempFiles[type] ?? [], ...res.data['data']];

      return res.status;
    } catch (e, s) {
      Errors.check(e, s);
      return false;
    }
  }

  void addFileSK(List<File> files) async {
    if (files.isEmpty) return;

    LzToast.overlay('Mengunggah file SK');
    final ok = await uploadFiles('sk', files);
    LzToast.dismiss();

    if (ok) {
      final newFiles = [...state.fileSK, ...files];
      state = state.copyWith(fileSK: newFiles);
    }
  }

  void addFileSupport(List<File> files) async {
    if (files.isEmpty) return;

    LzToast.overlay('Mengunggah file support');
    final ok = await uploadFiles('support', files);
    LzToast.dismiss();

    if (ok) {
      final newFiles = [...state.fileSupport, ...files];
      state = state.copyWith(fileSupport: newFiles);
    }
  }

  void addFileBeritaAcara(List<File> files) async {
    if (files.isEmpty) return;
    LzToast.overlay('Mengunggah file berita acara');
    final ok = await uploadFiles('operational_report', files);
    LzToast.dismiss();

    if (ok) {
      final newFiles = [...state.fileBeritaAcara, ...files];
      state = state.copyWith(fileBeritaAcara: newFiles);
    }
  }

  void addFileSuratPerjanjian(List<File> files) async {
    if (files.isEmpty) return;
    LzToast.overlay('Mengunggah file surat perjanjian');
    final ok = await uploadFiles('letter_of_agreement', files);
    LzToast.dismiss();

    if (ok) {
      final newFiles = [...state.fileSuratPerjanjian, ...files];
      state = state.copyWith(fileSuratPerjanjian: newFiles);
    }
  }

  void addFileOption(List<File> files) async {
    if (files.isEmpty) return;
    LzToast.overlay('Mengunggah file option');
    final ok = await uploadFiles('other', files);
    LzToast.dismiss();

    if (ok) {
      final newFiles = [...state.fileOption, ...files];
      state = state.copyWith(fileOption: newFiles);
    }
  }

  void removeFile(String label, int index) async {
    // find file id
    final id = tempFiles[label]![index]['id'];

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
            tempFiles['sk']?.removeAt(index);
            state = state.copyWith(fileSK: files);
            break;
          case 'support':
            List<File> files = state.fileSupport;
            files.removeAt(index);
            tempFiles['support']?.removeAt(index);
            state = state.copyWith(fileSupport: files);
            break;
          case 'operational_report':
            List<File> files = state.fileBeritaAcara;
            files.removeAt(index);
            tempFiles['operational_report']?.removeAt(index);
            state = state.copyWith(fileBeritaAcara: files);
            break;
          case 'letter_of_agreement':
            List<File> files = state.fileSuratPerjanjian;
            files.removeAt(index);
            tempFiles['letter_of_agreement']?.removeAt(index);
            state = state.copyWith(fileSuratPerjanjian: files);
            break;
          case 'other':
            List<File> files = state.fileOption;
            files.removeAt(index);
            tempFiles['other']?.removeAt(index);
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
        fileDokumentasiAmprahan: [],
        fileDokumentasiKegiatanName: [],
        fileDokumentasiAmprahan: [],
        fileDokumentasiAmprahanName: [],
        fileBuktiPajak: [],
        fileBuktiPajakName: [],
        totalRealisasiAnggaran: TextEditingController(),
        sumberDana: TextEditingController(),
        fileDokumentasiPajak: [],
        fileDokumentasiPajakName: [],
        amprahanDate: ''.tec,
        disbuermentDate: ''.tec,
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
    amprahans[index].fileDokumentasiKegiatan.addAll(files);
    amprahans[index].fileDokumentasiKegiatanName.addAll(files.map((e) => e.path.split('/').last).toList());

    state = state.copyWith(amprahans: amprahans);
  }

  void addFileDokumentasiAmprahan(List<File> files, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].fileDokumentasiAmprahan.addAll(files);
    amprahans[index].fileDokumentasiAmprahanName.addAll(files.map((e) => e.path.split('/').last).toList());

    state = state.copyWith(amprahans: amprahans);
  }

  void addFileDokumentasiPajak(List<File> files, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].fileDokumentasiPajak.addAll(files);
    amprahans[index].fileDokumentasiPajakName.addAll(files.map((e) => e.path.split('/').last).toList());

    state = state.copyWith(amprahans: amprahans);
  }

  void addFileBuktiPajak(List<File> files, int index) {
    List<Amprahan> amprahans = [...state.amprahans];
    amprahans[index].fileBuktiPajak.addAll(files);
    amprahans[index].fileBuktiPajakName.addAll(files.map((e) => e.path.split('/').last).toList());

    state = state.copyWith(amprahans: amprahans);
  }

  void removeFileAmprahan(String label, int index, int indexAmprahan) {
    List<Amprahan> amprahans = [...state.amprahans];
    switch (label) {
      case 'doc_kegiatan':
        List<File> files = amprahans[indexAmprahan].fileDokumentasiKegiatan;
        files.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiKegiatanName.removeAt(index);

        amprahans[indexAmprahan].fileDokumentasiKegiatan = files;
        state = state.copyWith(amprahans: amprahans);
        break;
      case 'amprahan_documentation':
        List<File> files = amprahans[indexAmprahan].fileDokumentasiAmprahan;
        files.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiAmprahanName.removeAt(index);

        amprahans[indexAmprahan].fileDokumentasiKegiatan = files;
        state = state.copyWith(amprahans: amprahans);
        break;
      case 'pajak':
        List<File> files = amprahans[indexAmprahan].fileDokumentasiPajak;
        files.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiPajakName.removeAt(index);
        amprahans[indexAmprahan].fileDokumentasiPajak = files;
        state = state.copyWith(amprahans: amprahans);
        break;

      case 'tax_receipt':
        List<File> files = amprahans[indexAmprahan].fileBuktiPajak;
        files.removeAt(index);
        amprahans[indexAmprahan].fileBuktiPajakName.removeAt(index);
        amprahans[indexAmprahan].fileBuktiPajak = files;
        state = state.copyWith(amprahans: amprahans);
        break;
      default:
    }
  }

  Future<List<MultipartFile>> fileToMultipart(List<File> files) async {
    List<MultipartFile> multipart = [];
    for (var e in files) {
      if (!e.path.toString().contains('http')) {
        final f = await kegiatanApi.toFile(e.path);
        multipart.add(f);
      }
    }

    return multipart;
  }

  // Future onSubmit(Kegiatan data) async {
  //   try {
  //     final fileSK = await fileToMultipart(state.fileSK);
  //     final fileBeritaAcara = await fileToMultipart(state.fileBeritaAcara);
  //     final fileOption = await fileToMultipart(state.fileOption);

  //     Map<String, dynamic> payload = {
  //       'file_sk': fileSK,
  //       'file_berita_acara': fileBeritaAcara,
  //       'file_option': fileOption,
  //     };

  //     if (state.amprahans.isNotEmpty) {
  //       List<Map<String, dynamic>> amprahans = [];

  //       for (Amprahan e in state.amprahans) {
  //         amprahans.add({
  //           'no_amprahan': e.noAmprahan.text,
  //           'total_realisasi_anggaran': e.totalRealisasiAnggaran.text,
  //           'sumber_dana': e.sumberDana.text,
  //           'file_dokumentasi_kegiatan': await fileToMultipart(e.fileDokumentasiKegiatan),
  //           'file_dokumentasi_pajak': await fileToMultipart(e.fileDokumentasiPajak),
  //           'pajak': true
  //         });
  //       }

  //       payload['amprahans'] = amprahans;
  //     }

  //     logg(payload);
  //   } catch (e, s) {
  //     Errors.check(e, s);
  //   }
  // }

  Future onSubmitAmprahan(int index) async {
    try {
      // get amprahan by index
      final amprahan = state.amprahans[index];

      LzToast.overlay(amprahan.id == null ? 'Menambahkan data amprahan...' : 'Mengubah data amprahan...');

      // get activity doc files
      final activityFiles = await fileToMultipart(amprahan.fileDokumentasiKegiatan);
      final activityAmprahan = await fileToMultipart(amprahan.fileDokumentasiAmprahan);
      final taxFiles = await fileToMultipart(amprahan.fileDokumentasiPajak);
      final taxReceipt = await fileToMultipart(amprahan.fileBuktiPajak);
      logg(amprahan.disbuermentDate.text);
      // make payload
      Map<String, dynamic> payload = {
        'amprahan_number': amprahan.noAmprahan.text,
        'total_budget_realisation':
            amprahan.totalRealisasiAnggaran.text.toString().replaceAll('.', '').replaceAll(',', ''),
        'budget_source': amprahan.sumberDana.text,
        'pajak': amprahan.isPajak == true ? 1 : 0,
        'amprahan_date': amprahan.amprahanDate.text,
        'disbuerment_date': amprahan.disbuermentDate.text == 'null' ? null : amprahan.disbuermentDate.text,
        'activity_id': kegiatan.id,
      };

      logg(payload);

      for (var i = 0; i < activityFiles.length; i++) {
        payload['activity_documentations[$i]'] = activityFiles[i];
      }
      for (var i = 0; i < activityAmprahan.length; i++) {
        payload['amprahan_documentation[$i]'] = activityAmprahan[i];
      }
      logg(payload);
      for (var i = 0; i < taxFiles.length; i++) {
        payload['tax_documentation[$i]'] = taxFiles[i];
      }

      for (var i = 0; i < taxReceipt.length; i++) {
        payload['tax_receipt[$i]'] = taxReceipt[i];
      }

      if (amprahan.id != null) {
        payload['amprahan_id'] = amprahan.id;
      }

      final res = await kegiatanApi.createAmprahan(payload);

      if (res.status) {
        if (amprahan.id != null) {
          LzToast.success('Berhasil mengubah data amprahan');
        } else {
          LzToast.success('Berhasil menambahkan data amprahan');
        }
      }
    } catch (e, s) {
      Errors.check(e, s);
      LzToast.error(e.toString());
    } finally {
      LzToast.dismiss();
    }
  }

  List<Option> getListSourceOfFound() {
    List<Option> listSourceOfFound = [
      const Option(option: 'ADD', value: 'ADD'),
      const Option(option: 'PBB', value: 'PBB'),
      const Option(option: 'DDS', value: 'DDS'),
      const Option(option: 'BKK', value: 'BKK'),
      const Option(option: 'DLL', value: 'DDL'),
    ];
    return listSourceOfFound;
  }
}

final formKegiatanProvider =
    StateNotifierProvider.autoDispose.family<FormKegiatanNotifier, FormKegiatanState, Kegiatan>((ref, kegiatan) {
  return FormKegiatanNotifier(kegiatan);
});

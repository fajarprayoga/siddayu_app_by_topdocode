import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class ActivtyTanggungjawabNotifier extends StateNotifier<AsyncValue<Kegiatan>>
    with UseApi {
  final String? activityId;
  final name = TextEditingController();
  final activity_date = TextEditingController();
  final description = TextEditingController();
  Map<String, List<Map<String, dynamic>>> fileListPro = {};

// for amprahan
  final TextEditingController noAmprahan = TextEditingController();
  final List<Map<String, dynamic>> documents = [];
  final TextEditingController totalRealisasi = TextEditingController();
  final TextEditingController sumberDana = TextEditingController();
  bool pajak = false;
  List<Map<String, List<Map<String, dynamic>>>> fileListAmprahan = [];

  List sub_activities = [];
  ActivtyTanggungjawabNotifier({this.activityId})
      : super(const AsyncValue.loading()) {
    if (activityId != '') getActivity();
  }

  Future getActivity() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanById(activityId ?? '');
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        final data = map['data']['data'];
        name.text = data['name'];
        activity_date.text = data['activity_date'].toString().split(' ')[0];

        description.text = data['description'];
        print(data);
        state = AsyncValue.data(Kegiatan.fromJson(data));
      }
    } catch (e, s) {
      AsyncValue.error(e, s);
    }
  }

  Future uploadDoc(BuildContext context, fileList, String type) async {
    try {
      if (fileList.isNotEmpty) {
        FormData formData = FormData();

        for (var i = 0; i < fileList.length; i++) {
          final fileName = fileList[i]['name'];
          final File file =
              fileList[i]['path']; // Diasumsikan ini adalah objek File

          formData.files.add(MapEntry(
            'files[]', // Menggunakan 'files[]' untuk menandai sebagai array
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
          addFile(type, fileList[i]['name'], fileList[i]['path']);
        }
        // Assuming you have the Dio setup and a URL endpoint
        final res = await kegiatanApi.uploadDoc(formData);
        final map = json.decode(res.data);
        if (res.statusCode == 201) {
          List pathFiles = map['data']['file_paths'];
          updateActivity(activityId ?? '', pathFiles);
        } else {
          print('nno');
        }
      } else {
        Toasts.show('No files to upload');
      }
    } catch (e, s) {
      print('Error: $e, $s');
      // Handle the error state
      // Example: state = AsyncValue.error(e, s);
    }
  }

  Future updateActivity(String activityId, fields) async {
    try {
      final data = {"sk": fields};
      final res = await kegiatanApi.updateKegiatan(activityId, data);
      if (res.statusCode == 200) {
        Toasts.show('Success');
        // final dataJson = jsonDecode(res.data);
        // final kegiatan = Kegiatan.fromJson(dataJson['data']['data'] ?? {});

        // state.whenData((data) {
        //     data[data.indexWhere((element) => element.id == activityId)] = kegiatan;
        //     state = AsyncValue.data(data);
        // });
      }
    } catch (e, s) {
      print('Error: $e, $s');
    }
  }

  // Amprahan
  Future updateAmprahan(String activityId, List data) async {
    List<FormData> formDataList = [];

    for (var entry in data.asMap().entries) {
      int index = entry.key; // Ini adalah index
      dynamic item = entry.value; // Ini adalah item pada index tersebut
      FormData form = FormData();

      // Menambahkan field non-file ke FormData
      form.fields.addAll([
        MapEntry('amprahan_number', item['amprahan_number'].toString()),
        MapEntry(
            'total_budget_realisation', item['total_budget_realisation'] ?? ""),
        MapEntry('budget_source', item['budget_source'].toString()),
        MapEntry('pajak', item['pajak'] ?? ''),
      ]);

      // Menambahkan dokumen
      // final fileList = item['documents'];
      // if (fileList.isNotEmpty) {
      //   for (var fileItem in fileList) {
      //     final fileName = fileItem['name'];
      //     final File file =
      //         fileItem['path']; // Diasumsikan ini adalah objek File

      //     form.files.add(MapEntry(
      //       'activity_documentations[]',
      //       await MultipartFile.fromFile(file.path, filename: fileName),
      //     ));
      //   }
      // }
      final fileList = item['documents'];
      FormData formFiles = FormData();

      // const List activityDocumentations = [];
      for (var i = 0; i < fileList.length; i++) {
        final fileName = fileList[i]['name'];
        final File file =
            fileList[i]['path']; // Diasumsikan ini adalah objek File

        formFiles.files.add(MapEntry(
          'files[]', // Menggunakan 'files[]' untuk menandai sebagai array
          await MultipartFile.fromFile(file.path, filename: fileName),
        ));
        // activityDocumentations[i] = {"name": fileName, "path": file.path};
      }

      // add to fielAmprahan
      // fileListAmprahan[index] = {
      //   "activity_documentations": [...activityDocumentations]
      // };

      // Menambahkan FormData ke list
      formDataList.add(form);
      print(formFiles.fields.isNotEmpty);
      if (formFiles != null && formFiles.fields.isNotEmpty) {
        final resFiles = kegiatanApi.uploadDoc(formFiles);
      }
    }

    // for (var i = 0; i < formDataList.length; i++) {

    // final res = await kegiatanApi.createAmprahan(activityId, formDataList[i]);
    // print(res);
    // }
    // Lakukan operasi yang diperlukan dengan formDataList
    // Misalnya, mengirimnya ke server atau proses lainnya
  }

  // Map<String, dynamic> addFileAmprahan(String name, File path) {
  //   return {
  //      "name": name, path: path}
  //   };
  // }

  void addFile(String type, String name, File path) {
    fileListPro[type] = fileListPro[type] ?? [];

    // Tambahkan file baru ke list
    fileListPro[type]!.add({"name": name, "path": path});
  }
}

final activitTanggungJawabProvider = StateNotifierProvider.autoDispose
    .family<ActivtyTanggungjawabNotifier, AsyncValue<Kegiatan>, String>(
        (ref, activityId) {
  return ActivtyTanggungjawabNotifier(activityId: activityId);
});

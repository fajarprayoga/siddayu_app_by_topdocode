import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class ActivtyTanggungjawabNotifier extends StateNotifier<AsyncValue<Kegiatan>>
    with Apis {
  final String? activityId;
  final name = TextEditingController();
  final activityDate = TextEditingController();
  final description = TextEditingController();
  Map<String, List<Map<String, dynamic>>> fileListPro = {};

// for amprahan
  final TextEditingController noAmprahan = TextEditingController();
  final List<Map<String, dynamic>> documents = [];
  final TextEditingController totalRealisasi = TextEditingController();
  final TextEditingController sumberDana = TextEditingController();
  bool pajak = false;
  List<Map<String, List<Map<String, dynamic>>>> fileListAmprahan = [];

  List subActivities = [];
  ActivtyTanggungjawabNotifier({this.activityId})
      : super(const AsyncValue.loading()) {
    if (activityId != '') getActivity();
  }

  Future getActivity() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanById(activityId ?? '');
      if (res.status) {
        final map = res.data;
        final data = map['data']['data'];
        name.text = data['name'];
        activityDate.text = data['activity_date'].toString().split(' ')[0];

        description.text = data['description'];
        state = AsyncValue.data(Kegiatan.fromJson(data));
      }
    } catch (e, s) {
      AsyncValue.error(e, s);
    }
  }

  Future uploadDoc(BuildContext context, fileList, String type) async {
    // try {
    //   if (fileList.isNotEmpty) {
    //     FormData formData = FormData();

    //     for (var i = 0; i < fileList.length; i++) {
    //       final fileName = fileList[i]['name'];
    //       final File file =
    //           fileList[i]['path']; // Diasumsikan ini adalah objek File

    //       formData.files.add(MapEntry(
    //         'files[]', // Menggunakan 'files[]' untuk menandai sebagai array
    //         await MultipartFile.fromFile(file.path, filename: fileName),
    //       ));
    //       addFile(type, fileList[i]['name'], fileList[i]['path']);
    //     }
    //     // Assuming you have the Dio setup and a URL endpoint
    //     final res = await kegiatanApi.uploadDoc(formData);
    //     final map = res.data;
    //     if (res.status) {
    //       List pathFiles = map['data']['file_paths'];
    //       updateActivity(activityId ?? '', pathFiles);

    //       // update state
    //     } else {
    //       Toasts.show('Activity not update');
    //     }
    //   } else {
    //     Toasts.show('No files to upload');
    //   }
    // } catch (e, s) {
    //   Utils.errorCatcher(e, s);
    // }
  }

  Future updateActivity(String activityId, fields) async {
    try {
      final data = {"sk": fields};
      final res = await kegiatanApi.updateKegiatan(activityId, data);
      if (res.status) {
        Toasts.show('Success');
        // final dataJson = jsonDecode(res.data);
        // final kegiatan = Kegiatan.fromJson(dataJson['data']['data'] ?? {});

        // update state
      }
    } catch (e, s) {
      // Utils.errorCatcher(e, s);
      Errors.check(e, s);
    }
  }

  // Amprahan
  Future updateAmprahan(String activityId, List data) async {
    // List<FormData> formDataList = [];

    // for (var entry in data.asMap().entries) {
    //   dynamic item = entry.value; // Ini adalah item pada index tersebut

    //   final fileList = item['documents'];
    //   FormData formFiles = FormData();

    //   // const List activityDocumentations = [];
    //   for (var i = 0; i < fileList.length; i++) {
    //     final fileName = fileList[i]['name'];
    //     final File file = fileList[i]['path'];

    //     formFiles.files.add(MapEntry(
    //       'files[]', // Menggunakan 'files[]' untuk menandai sebagai array
    //       await MultipartFile.fromFile(file.path, filename: fileName),
    //     ));
    //   }

    //   var mapFiles;
    //   bool statusUpload = true;
    //   List paths = [];
    //   if (formFiles.fields.isNotEmpty) {
    //     final resFiles = await kegiatanApi.uploadDoc(formFiles);

    //     if (resFiles.status) {
    //       mapFiles = resFiles.data;
    //     } else {
    //       statusUpload = false;
    //       Toasts.show("Doc not Uploaded");
    //     }
    //   }

    //   if (statusUpload) {
    //     paths = mapFiles['data']['file_paths'];
    //     // Menambahkan field non-file ke FormData
    //     final form = {
    //       "amprahan_number": item['amprahan_number'].toString(),
    //       "total_budget_realisation": item['total_budget_realisation'] ?? "",
    //       "budget_source": item['budget_source'].toString(),
    //       "pajak": item['pajak'] ?? false,
    //       "activity_documentations": paths
    //     };
    //     final res = await kegiatanApi.createAmprahan(activityId, form);

    //     if (res.status) {
    //       // update state
    //     }
    //   }
    // }
  }

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

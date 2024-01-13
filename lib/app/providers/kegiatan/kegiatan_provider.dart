import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/routes/paths.dart';

class SubActivity {
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  SubActivity({required this.nameController, required this.totalController});
}

class KegiatanNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>>
    with UseApi {
  KegiatanNotifier() : super(const AsyncValue.loading());

  String? authLocal = prefs.getString('auth');
  final name = TextEditingController();
  final activity_date = TextEditingController();
  final description = TextEditingController();
  List fileListSK = [];
  List sub_activities = [];

  Future getKegiatan() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatan();
      if (res.status) {
        final map = res.data;
        List data = map['data']['data'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      }
    } catch (e, s) {
      print('Error: $e, $s');
      state = AsyncValue.error(e, s);
    }
  }

  Future createKegiatan(BuildContext context) async {
    try {
      final formField = {
        "name": name.value.text,
        "description": description.value.text,
        "activity_date": activity_date.value.text,
        "sub_activities": sub_activities,
        // "created_by": auth.id
      };

      // final res = await kegiatanApi.addKegiatan(formField);
      // final map = json.decode(res.data);
      // if (res.statusCode == 201) {
      //   final data = map['data']['data'] ?? {};

      //   final kegiatan = Kegiatan.fromJson(data);
      //   state.whenData((value) {
      //     state = AsyncValue.data([...value, kegiatan]);
      //   });
      //   // context.push(Paths.formManagementTataKelolaDetail(null));
      //   context.pushReplacement(Paths.formManagementTataKelolaDetail,
      //       extra: kegiatan);
      //   Toasts.show('Kegiatan berhasil dibuat');
      // } else {
      //   Toasts.show(map['message']);
      // }
      print(formField);
    } catch (e, s) {
      print('Error: $e, $s');
      // state = AsyncValue.error(e, s);
    }
  }

  Future uploadDoc(BuildContext context) async {
    try {
      if (fileListSK.isNotEmpty) {
        FormData formData = FormData();

        for (var i = 0; i < fileListSK.length; i++) {
          final fileName = fileListSK[i]['name'];
          final File file =
              fileListSK[i]['path']; // Diasumsikan ini adalah objek File

          formData.files.add(MapEntry(
            'files[]', // Menggunakan 'files[]' untuk menandai sebagai array
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        }

        // Assuming you have the Dio setup and a URL endpoint
        final res = await kegiatanApi.uploadDoc(formData);
        if (res.status) {
          print('success');
        } else {
          print('nno');
        }

        // Handle the response
        // Example: print(response.data);
      } else {
        // Handle the case when files is null or empty
        print("No files to upload");
      }
    } catch (e, s) {
      print('Error: $e, $s');
      // Handle the error state
      // Example: state = AsyncValue.error(e, s);
    }
  }
}

final kegiatanProvider =
    StateNotifierProvider<KegiatanNotifier, AsyncValue<List<Kegiatan>>>((ref) {
  return KegiatanNotifier();
});

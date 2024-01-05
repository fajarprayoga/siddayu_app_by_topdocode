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
  List fileListPro = [];
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
        state = AsyncValue.data(Kegiatan.fromJson(data));
      }
    } catch (e, s) {
      AsyncValue.error(e, s);
    }
  }

  Future uploadDoc(BuildContext context, fileList, String type) async {
    try {
      if (fileList.isNotEmpty) {
        print(fileList);
        // FormData formData = FormData();

        // for (var i = 0; i < fileList.length; i++) {
        //   final Map<String, dynamic> fileTypeMap = fileList[i][type];
        //   final String fileName = fileTypeMap['files']['name'];
        //   final File file = fileTypeMap['files']['path'];

        //   formData.files.add(MapEntry(
        //     'files[]',
        //     await MultipartFile.fromFile(file.path, filename: fileName),
        //   ));
        // }

        // Assuming you have the Dio setup and a URL endpoint
        // final res = await kegiatanApi.uploadDoc(formData);
        // if (res.statusCode == 201) {
        //   print('success');
        // } else {
        //   print('nno');
        // }
      } else {
        Toasts.show('No files to upload');
      }

      print(fileList);
    } catch (e, s) {
      print('Error: $e, $s');
      // Handle the error state
      // Example: state = AsyncValue.error(e, s);
    }
  }

  Future updateActivity(String activityId, fields) async {
    try {
      final res = await kegiatanApi.updateKegiatan(activityId, fields);

      if (res.statusCode == 200) {
        final dataJson = jsonDecode(res.data);
        final kegiatan = Kegiatan.fromJson(dataJson['data']['data'] ?? {});

        // state.whenData((data) {
        //     data[data.indexWhere((element) => element.id == activityId)] = kegiatan;
        //     state = AsyncValue.data(data);
        // });
      }
    } catch (e, s) {
      print('Error: $e, $s');
    }
  }
}

final activitTanggungJawabProvider = StateNotifierProvider.family<
    ActivtyTanggungjawabNotifier,
    AsyncValue<Kegiatan>,
    String>((ref, activityId) {
  return ActivtyTanggungjawabNotifier(activityId: activityId);
});

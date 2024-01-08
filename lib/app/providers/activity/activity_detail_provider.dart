import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class SubActivity {
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  SubActivity({required this.nameController, required this.totalController});
}

class ActivtyDetailNotifier extends StateNotifier<AsyncValue<Kegiatan>>
    with UseApi {
  final String? activityId;
  final name = TextEditingController();
  final activity_date = TextEditingController();
  final description = TextEditingController();
  List fileList = [];
  List sub_activities = [];
  ActivtyDetailNotifier({this.activityId}) : super(const AsyncValue.loading()) {
    if (activityId != '') {
      getActivity();
    }
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

  Future createKegiatan(BuildContext context) async {
    try {
      final formField = {
        "name": name.value.text,
        "description": description.value.text,
        "activity_date": activity_date.value.text,
        "sub_activities": sub_activities,
        // "created_by": auth.id
      };

      final res = await kegiatanApi.addKegiatan(formField);
      final map = json.decode(res.data);
      if (res.statusCode == 201) {
        Toasts.show('Kegiatan berhasil dibuat');
      } else {
        Toasts.show(map['message']);
      }
    } catch (e, s) {
      print('Error: $e, $s');
      // state = AsyncValue.error(e, s);
    }
  }

  Future updateActivity(String activityId) async {
    try {
      // state = const AsyncValue.loading();
      final fields = {
        "name": name.value.text,
        "activity_date": activity_date.value.text,
        "description": description.value.text,
      };
      final res = await kegiatanApi.updateKegiatan(activityId, fields);

      if (res.statusCode == 200) {
        final dataJson = jsonDecode(res.data);
        Toasts.show("update successfully");
        // update state
      }
    } catch (e, s) {
      print('Error: $e, $s');
    }
  }

  void uploadDoc(BuildContext context) {}
}

final activityDetailProvider = StateNotifierProvider.family<
    ActivtyDetailNotifier, AsyncValue<Kegiatan>, String>((ref, activityId) {
  return ActivtyDetailNotifier(activityId: activityId);
});

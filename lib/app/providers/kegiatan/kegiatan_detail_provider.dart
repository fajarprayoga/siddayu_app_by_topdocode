import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class SubActivity {
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  SubActivity({required this.nameController, required this.totalController});
}

class KegiatanDetailNotifier extends StateNotifier<AsyncValue<Kegiatan>>
    with UseApi {
  final String activityId;
  final name = TextEditingController();
  final activity_date = TextEditingController();
  final description = TextEditingController();
  List sub_activities = [];
  KegiatanDetailNotifier({required this.activityId})
      : super(const AsyncValue.loading()) {
    getActivity();
  }
  Future getActivity() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanById(activityId);
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        final data = map['data']['data'];
        name.text = data['name'];
        activity_date.text = data['activity_date'].toString().split(' ')[0];

        description.text = data['description'];
        state = AsyncValue.data(Kegiatan.fromJson(data));
      }
    } catch (e, s) {
      print('Error: $e, $s');
    }
  }

  Future updateActivity(String activityId) async {
    try {
      state = const AsyncValue.loading();
      final fields = {
        "name": name.value.text,
        "activity_date": activity_date.value.text,
        "description": description.value.text,
      };
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

final kegiatanDetailProvider = StateNotifierProvider.autoDispose
    .family<KegiatanDetailNotifier, AsyncValue<Kegiatan>, String>(
        (ref, activityId) {
  return KegiatanDetailNotifier(activityId: activityId);
});

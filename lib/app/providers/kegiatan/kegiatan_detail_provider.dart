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
}

final kegiatanDetailProvider = StateNotifierProvider.autoDispose
    .family<KegiatanDetailNotifier, AsyncValue<Kegiatan>, String>(
        (ref, activityId) {
  return KegiatanDetailNotifier(activityId: activityId);
});

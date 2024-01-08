import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

class ActivityNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>>
    with UseApi {
  ActivityNotifier() : super(const AsyncValue.loading());

  String? authLocal = prefs.getString('auth');
  final name = TextEditingController();
  final description = TextEditingController();

  Future getKegiatan() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatan();
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['data']['data'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      }
    } catch (e, s) {
      print('error: $s');
      state = AsyncValue.error(e, s);
    }
  }
}

final activityProvider =
    StateNotifierProvider<ActivityNotifier, AsyncValue<List<Kegiatan>>>((ref) {
  return ActivityNotifier();
});

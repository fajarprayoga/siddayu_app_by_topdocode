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

class KegiatanByUserNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>>
    with UseApi {
  final String userId;
  final name = TextEditingController();
  final activity_date = TextEditingController();
  final description = TextEditingController();
  KegiatanByUserNotifier({required this.userId})
      : super(const AsyncValue.loading()) {
    getKegiatan();
  }

  Future getKegiatan() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanByUser(userId);
      print(res);
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['data']['data'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      }
    } catch (e, s) {
      print('Error: $e, $s');
      state = AsyncValue.error(e, s);
    }
  }
}

final kegiatanByUserProvider = StateNotifierProvider.autoDispose
    .family<KegiatanByUserNotifier, AsyncValue<List<Kegiatan>>, String>(
        (ref, userId) {
  return KegiatanByUserNotifier(userId: userId);
});

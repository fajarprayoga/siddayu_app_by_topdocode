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

class ActivityUserNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>> with UseApi {
  final String userId;
  ActivityUserNotifier({required this.userId}) : super(const AsyncValue.loading()) {
    getKegiatan();
  }

  Future getKegiatan() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanByUser(userId);
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['data']['data'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void addData(Kegiatan data) {
    try {
      final currentState = state.value ?? [];
      state = AsyncValue.data([data, ...currentState]);
    } catch (e, s) {
      print('error: $e, $s');
    }
  }

  void updateData(Kegiatan data) {
    try {
      final currentState = state.value ?? [];
      final index = currentState.indexWhere((element) => element.id == data.id);
      currentState[index] = data;
      state = AsyncValue.data(currentState);
    } catch (e, s) {
      print('error: $e, $s');
    }
  }
}

final activityUserProvider = StateNotifierProvider.autoDispose.family<ActivityUserNotifier, AsyncValue<List<Kegiatan>>, String>((ref, userId) {
  return ActivityUserNotifier(userId: userId);
});

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';

import '../../data/service/local/auth.dart';

class SubActivity {
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  SubActivity({required this.nameController, required this.totalController});
}

class ActivityUserNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>> with Apis {
  final String userId;
  ActivityUserNotifier({required this.userId}) : super(const AsyncValue.loading()) {
    getKegiatan();
  }

  bool isUserLogged = false;
  Future getKegiatan() async {
    try {
      final auth = await Auth.user();
      isUserLogged = auth.id == userId;
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanByUser(userId);
      if (res.status) {
        List data = res.data['data'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, s) {
      Errors.check(e, s);
      // state = AsyncValue.error(e, s);
    }
  }

  void addData(Kegiatan data) {
    try {
      final currentState = state.value ?? [];
      state = AsyncValue.data([data, ...currentState]);
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void updateData(Kegiatan data) {
    try {
      final currentState = state.value ?? [];
      final index = currentState.indexWhere((element) => element.id == data.id);
      currentState[index] = data;
      state = AsyncValue.data(currentState);
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void deleteData(String id) async {
    try {
      LzToast.overlay('Menghapus data...');
      final res = await kegiatanApi.deleteActivity(id);

      if (!res.status) {
        return LzToast.error(res.message ?? 'Gagal menghapus data');
      }

      // remove data from state
      final currentState = state.value ?? [];
      final index = currentState.indexWhere((e) => e.id == id);
      currentState.removeAt(index);

      // update state
      state = AsyncValue.data(currentState);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }
}

final activityUserProvider =
    StateNotifierProvider.autoDispose.family<ActivityUserNotifier, AsyncValue<List<Kegiatan>>, String>((ref, userId) {
  return ActivityUserNotifier(userId: userId);
});

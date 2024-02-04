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

class ActivityDataState {
  final AsyncValue<List<Kegiatan>> activities;
  bool isPaginating = false;

  ActivityDataState(
      {this.activities = const AsyncValue.loading(),
      this.isPaginating = false});

  ActivityDataState copyWith(
      {AsyncValue<List<Kegiatan>>? activities, bool? isPaginating}) {
    return ActivityDataState(
        activities: activities ?? this.activities,
        isPaginating: isPaginating ?? this.isPaginating);
  }
}

class ActivityUserNotifier extends StateNotifier<ActivityDataState> with Apis {
  final String userId;
  ActivityUserNotifier({required this.userId}) : super(ActivityDataState()) {
    getKegiatan();
  }

  bool isUserLogged = false, isPaginate = false, isAllReaches = false;
  int page = 1, total = 0;

  Future getKegiatan() async {
    try {
      page = 1;

      final auth = await Auth.user();
      isUserLogged = auth.id == userId;
      state = state.copyWith(activities: const AsyncValue.loading());
      final res = await kegiatanApi.getKegiatanByUser(userId, page);
      if (res.status) {
        total = res.body?['data']?['meta']?['total'] ?? 0;
        List data = res.data['data'] ?? [];
        state = state.copyWith(
            activities: AsyncValue.data(
                data.map((e) => Kegiatan.fromJson(e)).toList()));
        isAllReaches = data.length >= total;
      } else {
        state = state.copyWith(activities: const AsyncValue.data([]));
      }
    } catch (e, s) {
      Errors.check(e, s);
      // state = AsyncValue.error(e, s);
    }
  }

  void onGetMore() async {
    try {
      if (isPaginate) return;
      if ((state.activities.value ?? []).length >= total) {
        isAllReaches = true;
        return;
      }

      page++;
      isPaginate = true;
      state = state.copyWith(isPaginating: true);

      final res = await kegiatanApi.getKegiatanByUser(userId, page);
      List data = res.data['data'];
      List<Kegiatan> activities =
          data.map((e) => Kegiatan.fromJson(e)).toList();
      state = state.copyWith(
          activities: AsyncValue.data(
              [...(state.activities.value ?? []), ...activities]));
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      await Future.delayed(500.ms);
      isPaginate = false;
      state = state.copyWith(isPaginating: false);
    }
  }

  void addData(Kegiatan data) {
    try {
      final currentState = state.activities.value ?? [];
      state =
          state.copyWith(activities: AsyncValue.data([data, ...currentState]));
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void updateData(Kegiatan data) {
    try {
      final currentState = state.activities.value ?? [];
      final index = currentState.indexWhere((element) => element.id == data.id);
      currentState[index] = data;
      state = state.copyWith(activities: AsyncValue.data(currentState));
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
      final currentState = state.activities.value ?? [];
      final index = currentState.indexWhere((e) => e.id == id);
      currentState.removeAt(index);

      // update state
      state = state.copyWith(activities: AsyncValue.data(currentState));
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }
}

final activityUserProvider = StateNotifierProvider.autoDispose
    .family<ActivityUserNotifier, ActivityDataState, String>((ref, userId) {
  return ActivityUserNotifier(userId: userId);
});

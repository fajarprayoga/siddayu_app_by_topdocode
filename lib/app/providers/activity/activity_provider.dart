import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

class ActivityState {
  final AsyncValue<List<Kegiatan>> activities;
  bool isUpdating = false;
  bool isPaginate = false;

  ActivityState(
      {this.activities = const AsyncValue.loading(),
      this.isUpdating = false,
      this.isPaginate = false});

  ActivityState copyWith(
      {AsyncValue<List<Kegiatan>>? activities,
      bool? isUpdating,
      bool? isPaginate}) {
    return ActivityState(
        activities: activities ?? this.activities,
        isUpdating: isUpdating ?? this.isUpdating,
        isPaginate: isPaginate ?? this.isPaginate);
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> with Apis {
  ActivityNotifier() : super(ActivityState());

  String? authLocal = prefs.getString('auth');
  final name = TextEditingController();
  final description = TextEditingController();

  AsyncValue<List<Kegiatan>> get getActivities => state.activities;
  int page = 1, total = 0;
  bool isPaginate = false, isAllReaches = false;

  Future getKegiatan() async {
    try {
      page = 1;
      state = state.copyWith(activities: const AsyncValue.loading());
      final res = await kegiatanApi.getKegiatan(page);
      if (res.status) {
        total = res.body?['data']?['meta']?['total'] ?? 0;
        List data = res.data['data'] ?? [];
        state = state.copyWith(
            activities: AsyncValue.data(
                data.map((e) => Kegiatan.fromJson(e)).toList()));
        isAllReaches = data.length >= total;
      }
    } catch (e, s) {
      Errors.check(e, s);
      state = state.copyWith(activities: const AsyncValue.data([]));
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
      state = state.copyWith(isPaginate: true);

      final res = await kegiatanApi.getKegiatan(page);
      if (res.status) {
        List data = res.data['data'] ?? [];
        state = state.copyWith(
            activities: AsyncValue.data([
          ...state.activities.value ?? [],
          ...data.map((e) => Kegiatan.fromJson(e)).toList()
        ]));
      }
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      await Future.delayed(500.ms);
      isPaginate = false;
      state = state.copyWith(isPaginate: false);
    }
  }

  Future updateActivityProgress() async {
    try {
      state = state.copyWith(isUpdating: true);
      final res = await kegiatanApi.getKegiatan(page);
      if (res.status) {
        List data = res.data['data'] ?? [];
        state = state.copyWith(
            activities: AsyncValue.data(
                data.map((e) => Kegiatan.fromJson(e)).toList()));
      }
    } catch (e, s) {
      Errors.check(e, s);
      state = state.copyWith(activities: const AsyncValue.data([]));
    } finally {
      state = state.copyWith(isUpdating: false);
    }
  }
}

final activityProvider =
    StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

class ActivityState {
  final AsyncValue<List<Kegiatan>> activities;
  bool isUpdating = false;

  ActivityState({this.activities = const AsyncValue.loading(), this.isUpdating = false});

  ActivityState copyWith({AsyncValue<List<Kegiatan>>? activities, bool? isUpdating}) {
    return ActivityState(activities: activities ?? this.activities, isUpdating: isUpdating ?? this.isUpdating);
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> with Apis {
  ActivityNotifier() : super(ActivityState());

  String? authLocal = prefs.getString('auth');
  final name = TextEditingController();
  final description = TextEditingController();

  AsyncValue<List<Kegiatan>> get getActivities => state.activities;

  Future getKegiatan() async {
    try {
      state = state.copyWith(activities: const AsyncValue.loading());
      final res = await kegiatanApi.getKegiatan();
      if (res.status) {
        List data = res.data['data'] ?? [];
        state = state.copyWith(activities: AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList()));
      }
    } catch (e, s) {
      Errors.check(e, s);
      state = state.copyWith(activities: const AsyncValue.data([]));
    }
  }

  Future updateActivityProgress() async {
    try {
      state = state.copyWith(isUpdating: true);
      final res = await kegiatanApi.getKegiatan();
      if (res.status) {
        List data = res.data['data'] ?? [];
        state = state.copyWith(activities: AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList()));
      }
    } catch (e, s) {
      Errors.check(e, s);
      state = state.copyWith(activities: const AsyncValue.data([]));
    } finally {
      state = state.copyWith(isUpdating: false);
    }
  }
}

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});

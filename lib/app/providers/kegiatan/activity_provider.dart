import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/kegiatan/kegiatan.dart';

class ActivityState {
  final DateTimeRange? date;
  final List<Kegiatan> activities;
  bool isPaginating = false;

  ActivityState(
      {this.date, this.activities = const [], this.isPaginating = false});

  ActivityState copyWith(
      {DateTimeRange? date, List<Kegiatan>? activities, bool? isPaginating}) {
    return ActivityState(
        date: date ?? this.date,
        activities: activities ?? this.activities,
        isPaginating: isPaginating ?? this.isPaginating);
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> with Apis {
  ActivityNotifier() : super(ActivityState());

  final keyword = TextEditingController();

  String get getDate {
    if (state.date == null) {
      return '';
    } else {
      return '${state.date?.start.format('dd/MM/yyyy')} - ${state.date?.end.format('dd/MM/yyyy')}';
    }
  }

  DateTimeRange get dateRange =>
      state.date ?? DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void setDate(DateTimeRange? date) {
    state = state.copyWith(date: date);
  }

  int page = 1, total = 0;

  void doSearch() async {
    try {
      page = 1;
      if (state.date == null) {
        return LzToast.show('Pilih tanggal terlebih dahulu');
      }

      LzToast.overlay('Mencari kegiatan...');

      final dates = [
        '${state.date?.start.format('yyyy')}',
        '${state.date?.end.format('yyyy')}'
      ];
      final res = await kegiatanApi.searchActivity(keyword.text, dates, page);
      List data = res.data['data'];
      state = state.copyWith(
          activities: data.map((e) => Kegiatan.fromJson(e)).toList());
      total = res.data?['meta']?['total'] ?? 0;
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }

  void onGetMore() async {
    try {
      if (state.isPaginating) return;
      if (state.activities.length >= total) return;

      state = state.copyWith(isPaginating: true);

      page++;
      final dates = [
        '${state.date?.start.format('yyyy')}',
        '${state.date?.end.format('yyyy')}'
      ];
      final res = await kegiatanApi.searchActivity(keyword.text, dates, page);
      List data = res.data['data'];
      state = state.copyWith(activities: [
        ...state.activities,
        ...data.map((e) => Kegiatan.fromJson(e)).toList()
      ]);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      state = state.copyWith(isPaginating: false);
    }
  }

  void updateData(Kegiatan data) {
    try {
      final currentState = state.activities;
      final index = currentState.indexWhere((element) => element.id == data.id);
      currentState[index] = data;
      state = state.copyWith(activities: currentState);
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
      final currentState = state.activities;
      final index = currentState.indexWhere((e) => e.id == id);
      currentState.removeAt(index);

      // update state
      state = state.copyWith(activities: currentState);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }
}

final allActivityProvider =
    StateNotifierProvider.autoDispose<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});

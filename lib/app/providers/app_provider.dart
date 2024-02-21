import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/providers/activity/activity_provider.dart';
import 'package:todo_app/app/providers/user/user_provider.dart';

import '../data/service/local/storage.dart';

// import 'todo/todo_provider.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  final StateNotifierProviderRef ref;
  AppStateNotifier(this.ref) : super(AppState());

  List<int> visited = [];

  void navigateTo(int index) {
    state = state.copyWith(page: index);

    switch (index) {
      case 1:
        if (!visited.contains(index)) {}
      case 2:
        if (!visited.contains(index)) {
          ref.read(userProvider.notifier).getStaffUsers();
          ref.read(activityProvider.notifier).getKegiatan();
        }
        break;
      default:
    }

    if (!visited.contains(index)) {
      visited.add(index);
    }
  }

  Future logout() async {
    prefs.remove('token');
    prefs.remove('auth');
  }

  void setState() {
    state = state.copyWith(date: DateTime.now());
  }
}

class AppState {
  final int page;
  final DateTime date = DateTime.now();

  AppState({this.page = 0, DateTime? date});

  AppState copyWith({int? page, DateTime? date}) {
    return AppState(
      page: page ?? this.page,
      date: date ?? this.date,
    );
  }
}

final appStateProvider = StateNotifierProvider.autoDispose<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(ref);
});

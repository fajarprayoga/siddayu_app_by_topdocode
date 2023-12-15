import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/providers/kegiatan/kegiatan_detail_provider.dart';
import 'package:todo_app/app/providers/user/user_provider.dart';

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
        // if (!visited.contains(index)) {
        // ;
        ref.read(userProvider.notifier).getUserStaff();
        ref.read(kegiatanDetailProvider.notifier).getKegiatan();
        // }
        break;
      default:
    }

    if (!visited.contains(index)) {
      visited.add(index);
    }
  }
}

class AppState {
  final int page;

  AppState({this.page = 0});

  AppState copyWith({int? page}) {
    return AppState(
      page: page ?? this.page,
    );
  }
}

final appStateProvider =
    StateNotifierProvider.autoDispose<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(ref);
});

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/user/user.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> with Apis {
  UserNotifier() : super(const AsyncValue.loading());

  Future getStaffUsers() async {
    try {
      state = const AsyncValue.loading();
      final res = await userApi.getUsers();

      if (res.status) {
        List data = res.data['data'] ?? [];
        state = AsyncValue.data(data.map((e) => User.fromJson(e)).toList());
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>((ref) {
  return UserNotifier();
});

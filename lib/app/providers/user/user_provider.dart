import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/user.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> with UseApi {
  UserNotifier() : super(const AsyncValue.loading());
  final title = 'as';
  Future getUserStaff() async {
    try {
      state = const AsyncValue.loading();
      final res = await userApi.getUsers();

      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['users'] ?? [];
        state = AsyncValue.data(data.map((e) => User.fromJson(e)).toList());
      }
    } catch (e, s) {
      print('Error: $e, $s');
      state = AsyncValue.error(e, s);
    } finally {
      // Anything that needs to be executed regardless of the result
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>((ref) {
  return UserNotifier();
});

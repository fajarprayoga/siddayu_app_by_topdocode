import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/user.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> with UseApi {
  UserNotifier() : super(const AsyncValue.loading());

  Future<void> getUserStaff() async {
    try {
      state = const AsyncValue.loading();

      // Uncomment the following line if you have a real API to fetch data
      // final api = ref.read(apiProvider);

      // Replace the following line with an actual API call
      // List<Map<String, dynamic>> resData = await api.fetchUserData();

      // For now, use mock data
      List<Map<String, dynamic>> resData = [
        {
          'id': 1,
          'username': 'rama',
          'email': 'rama@example.com',
          'firstName': 'rama',
          'lastName': 'widana',
          'gender': 'male',
          'image': '',
          'position': 'staff'
        }
      ];

      // Simulate an API call by converting data into User models
      final List<User> userList = resData.map((e) => User.fromJson(e)).toList();
      state = AsyncValue.data(userList);
    } catch (e, s) {
      print('Error: $e, $s');
      state = AsyncValue.error(e, s);
    } finally {
      // Anything that needs to be executed regardless of the result
    }
  }
}

final userProvider =
    StateNotifierProvider.autoDispose<UserNotifier, AsyncValue<List<User>>>(
        (ref) {
  return UserNotifier();
});

part of api;

class AuthApi extends Fetchly {
  Future<ResHandler> login(Map<String, dynamic> data) async =>
      await post('auth/login', data);
  Future<ResHandler> getAuth() async => await get('login/user');
  Future<ResHandler> getUserStaff() async => await get('users');
}

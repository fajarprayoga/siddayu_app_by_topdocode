part of api;

class UserApi extends Fetchly {
  Future<ResHandler> getUsers() async => await get('user');
}

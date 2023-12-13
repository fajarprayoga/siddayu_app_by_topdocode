part of api;

class UserApi {
  Future<Response> getUsers() async {
    return await dio.get('users?limit=6');
  }
}

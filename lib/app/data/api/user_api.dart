part of api;

class UserApi {
  Future<Response> getUsers() async {
    return await dio.get('api/users');
  }
}

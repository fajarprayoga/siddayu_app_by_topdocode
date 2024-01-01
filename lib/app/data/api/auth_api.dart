part of api;

class AuthApi {
  Future<Response> login(Map<String, dynamic> data) async {
    return await dio.post('api/auth/login', data: data);
  }

  Future<Response> getAuth() async {
    return await dio.get('api/login/users');
  }

  Future<Response> getUserStaff() async {
    return await dio.get('api/users');
  }
}

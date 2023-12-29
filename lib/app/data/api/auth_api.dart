part of api;

class AuthApi {
  Future<Response> login(Map<String, dynamic> data) async {
    return await dio.post('api/auth/login', data: data);
  }

  Future<Response> getAuth(String id) async {
    return await dio.get('api/login/user/$id');
  }

  Future<Response> getUserStaff() async {
    return await dio.get('api/users');
  }
}

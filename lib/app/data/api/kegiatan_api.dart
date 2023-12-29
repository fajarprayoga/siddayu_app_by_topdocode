part of api;

class KegiatanApi {
  Future<Response> getKegiatan() async {
    return await dio.get('api/activities');
  }

  Future<Response> addKegiatan(Map<String, dynamic> data) async {
    return await dio.post('todos/add', data: data);
  }
}

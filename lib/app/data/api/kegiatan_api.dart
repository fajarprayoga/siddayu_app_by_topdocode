part of api;

class KegiatanApi {
  Future<Response> getKegiatanByUser(String userId) async {
    return await dio.get('api/activities/?user_id=$userId');
  }

  Future<Response> getKegiatan() async {
    return await dio.get('api/activities');
  }

  Future<Response> addKegiatan(Map<String, dynamic> data) async {
    return await dio.post('api/activities', data: data);
  }

  Future<Response> uploadDoc(data) async {
    return await dio.post('api/upload/multiple', data: data);
  }

  Future<Response> getKegiatanById(String id) async {
    return await dio.get('api/activities/$id');
  }

  Future<Response> updateKegiatan(String id, Map<String, dynamic> data) async {
    return await dio.patch('api/activities/$id', data: data);
  }
}

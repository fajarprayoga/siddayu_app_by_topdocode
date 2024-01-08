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

  Future<Response> createAmprahan(String activityId, data) async {
    return await dio.post('api/activity/$activityId/amprahan', data: data);
  }
}

class KegiatanApi2 extends Fetchly {
  Future<ResHandler> getKegiatan() async {
    return await get('api/activities');
  }

  Future<ResHandler> getKegiatanById(String id) async {
    return await get('api/activities/$id');
  }

  Future<ResHandler> addKegiatan(Map<String, dynamic> data) async {
    return await post('api/activities', data);
  }

  Future<ResHandler> updateKegiatan(String id, Map<String, dynamic> data) async {
    return await put('api/activities/$id', data);
  }
}

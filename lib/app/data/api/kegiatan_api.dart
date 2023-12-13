part of api;

class KegiatanApi {
  Future<Response> getKegiatan() async {
    return await dio.get('todos?limit=40');
  }
}

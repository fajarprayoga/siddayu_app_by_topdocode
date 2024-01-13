part of api;

class KegiatanApi extends Fetchly {
  Future<ResHandler> getKegiatanByUser(String userId) async {
    return await get('api/activities?user_id=$userId');
  }

  Future<ResHandler> getKegiatan() async {
    return await get('api/activities');
  }

  Future<ResHandler> addKegiatan(Map<String, dynamic> data) async {
    return await post('api/activities', data);
  }

  Future<ResHandler> uploadDoc(data) async {
    return await post('api/upload/multiple', data);
  }

  Future<ResHandler> getKegiatanById(String id) async {
    return await get('api/activities/$id');
  }

  Future<ResHandler> updateKegiatan(
      String id, Map<String, dynamic> data) async {
    return await post('api/activities/$id', data);
  }

  Future<ResHandler> createAmprahan(String activityId, data) async {
    return await post('api/activity/$activityId/amprahan', data);
  }
}

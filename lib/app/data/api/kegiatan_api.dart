part of api;

class KegiatanApi extends Fetchly {
  Future<ResHandler> getKegiatanByUser(String userId) async => await get('activities?user_id=$userId');
  Future<ResHandler> getKegiatan() async => await get('activities');
  Future<ResHandler> addKegiatan(Map<String, dynamic> data) async => await post('activities', data);
  Future<ResHandler> uploadDoc(data) async => await post('upload/multiple', data);
  Future<ResHandler> getKegiatanById(String id) async => await get('activities/$id');
  Future<ResHandler> updateKegiatan(String id, Map<String, dynamic> data) async => await put('activities/$id', data);
  Future<ResHandler> createAmprahan(String activityId, data) async => await post('activity/$activityId/amprahan', data);
}

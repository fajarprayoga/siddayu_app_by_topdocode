part of api;

class KegiatanApi extends Fetchly {
  Future<ResHandler> getKegiatanByUser(String userId) async => await get('activities?user_id=$userId');
  Future<ResHandler> getKegiatan() async => await get('activities');
  Future<ResHandler> addKegiatan(Map<String, dynamic> data) async => await post('activities', data);

  Future<ResHandler> uploadDoc(Map<String, dynamic> data) async =>
      await post('upload/multiple', data, useFormData: true);
  Future<ResHandler> deleteDoc(String id) async => await post('document/batch-delete', {
        'id': [id]
      });

  Future<ResHandler> getKegiatanById(String id) async => await get('activities/$id');
  Future<ResHandler> updateKegiatan(String id, Map<String, dynamic> data) async => await put('activities/$id', data);
  Future<ResHandler> createAmprahan(Map<String, dynamic> data) async =>
      await post('activity/amprahan/create-update', data, useFormData: true);

  Future<ResHandler> getAmprahanFiles(String id) async => await get('activities/$id?documents=true');
  Future<ResHandler> getAmprahan(String id) async => await get('activity/$id/amprahan');
  Future<ResHandler> deleteAmprahan(String id) async => await delete('amprahan/$id');

  Future<ResHandler> deleteActivity(String id) async => await delete('activities/$id');
}

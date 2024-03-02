part of api;

class AssetApi extends Fetchly {
  Future<ResHandler> getDocuments(String activityID) async => await get('/documents/all/$activityID');
  Future<ResHandler> downloadDocuments(String activityID) async => await get('/documents/download/$activityID');
}

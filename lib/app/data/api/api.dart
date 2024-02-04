library api;

import 'package:fetchly/fetchly.dart';

part 'auth_api.dart';
part 'user_api.dart';
part 'kegiatan_api.dart';
part 'asset.dart';

mixin Apis {
  AuthApi authApi = AuthApi();
  UserApi userApi = UserApi();
  KegiatanApi kegiatanApi = KegiatanApi();
  AssetApi assetApi = AssetApi();
}

import 'package:go_router/go_router.dart';
import 'package:lazyui/lazyui.dart';

import '../../data/service/local/storage.dart';
import '../../routes/paths.dart';
import '../constants/value.dart';

class RequestHandler {
  static onRequest(String path, int status, dynamic data) {
    if (status == 401) {
      LzToast.show('Unauthorized, please login again.');

      prefs.remove('token');
      globalContext.go(Paths.login);
    }
  }
}

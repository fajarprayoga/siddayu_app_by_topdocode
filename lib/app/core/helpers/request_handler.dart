import 'package:fetchly/models/request.dart';
import 'package:go_router/go_router.dart';
import 'package:lazyui/lazyui.dart' hide Request;

import '../../data/service/local/storage.dart';
import '../../routes/paths.dart';
import '../constants/value.dart';

class RequestHandler {
  static onRequest(Request request) async {
    int status = request.status;

    if (status == 401) {
      LzToast.show('Unauthorized, please login again.');

      prefs.remove('token');
      globalContext.go(Paths.login);
    }

    if (![200, 201].contains(status)) {
      final device = await Utils.getDevice();
      String message =
          request.log.toString().replaceAll('-- ', '').replaceAll('== ', '');

      Bot.sendMessage(
          '<b>Error Info</b>\n$message\n<b>Device Info</b>\n${device.value}',
          botToken,
          chatId);
    }
  }

  static onError(Object e, StackTrace s) {
    logg('error: $e, $s');
  }
}

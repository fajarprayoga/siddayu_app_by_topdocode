import 'dart:convert';

import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/models/user/user.dart';

import 'storage.dart';

class Auth {
  static Future<User> user() async {
    try {
      final data = prefs.getString('auth') ?? '{}';
      return User.fromJson(json.decode(data));
    } catch (e, s) {
      Errors.check(e, s);
      return User();
    }
  }
}

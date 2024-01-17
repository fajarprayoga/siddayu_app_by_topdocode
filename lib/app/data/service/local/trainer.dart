import 'package:todo_app/app/data/service/local/storage.dart';

enum TType { activity }

class Trainer {
  static void set(TType type) {
    prefs.setBool(type.toString(), true);
  }

  static bool get(TType type) {
    return prefs.getBool(type.toString()) ?? false;
  }
}

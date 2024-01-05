import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan%20copy.dart';

class ActivityNotifier extends StateNotifier with UseApi {
  ActivityNotifier() : super([]);

  Future getKegiatan() async {
    try {
      final res = await kegiatanApi.getKegiatan();
      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['data']['data'] ?? [];
        return data.map((e) => Kegiatan.fromJson(e)).toList();
      }
    } catch (e, s) {
      print('Error: $e, $s');
      return false;
    }
  }
}

final activityProvider =
    StateNotifierProvider.autoDispose((ref) => ActivityNotifier());

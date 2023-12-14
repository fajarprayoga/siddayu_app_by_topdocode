import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class KegiatanDetailNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>>
    with UseApi {
  KegiatanDetailNotifier() : super(const AsyncValue.loading());

  Future getKegiatan() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatan();

      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        List data = map['todos'] ?? [];
        state = AsyncValue.data(data.map((e) => Kegiatan.fromJson(e)).toList());
      }
    } catch (e, s) {
      print('Error: $e, $s');
      state = AsyncValue.error(e, s);
    }
  }
}

final kegiatanDetailProvider =
    StateNotifierProvider<KegiatanDetailNotifier, AsyncValue<List<Kegiatan>>>(
        (ref) {
  return KegiatanDetailNotifier();
});

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class KegiatanDetailNotifier extends StateNotifier<AsyncValue<Kegiatan>>
    with UseApi {
  KegiatanDetailNotifier() : super(const AsyncValue.loading());

  Future getKegiatan() async {
    try {} catch (e) {}
  }
}

final kegiatanDetailProvider = StateNotifierProvider.autoDispose<
    KegiatanDetailNotifier, AsyncValue<Kegiatan>>((ref) {
  return KegiatanDetailNotifier();
});

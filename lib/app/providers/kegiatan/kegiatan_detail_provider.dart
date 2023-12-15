import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class KegiatanDetailNotifier extends StateNotifier<AsyncValue<List<Kegiatan>>>
    with UseApi {
  KegiatanDetailNotifier() : super(const AsyncValue.loading());

  final namaKegiatan = TextEditingController();
  final tanggalKegiatan = TextEditingController();
  final deskripsi = TextEditingController();

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

  Future createKegiatan() async {
    try {
      // if (namaKegiatan.value.text.trim().isEmpty ||
      //     tanggalKegiatan.value.text.trim().isEmpty ||
      //     deskripsi.value.text.trim().isEmpty) {
      //   return Toasts.show('Please fill all the fields');
      // }

      final res = await kegiatanApi.addKegiatan(
          {'todo': namaKegiatan.value.text, 'userId': 5, 'completed': false});

      if (res.statusCode == 200) {
        final map = json.decode(res.data);
        final data = map ?? {};
        final kegiatan = Kegiatan.fromJson(data);
        state.whenData((value) {
          state = AsyncValue.data([...value, kegiatan]);
        });
        Toasts.show('Kegiatan berhasil dibuat');
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

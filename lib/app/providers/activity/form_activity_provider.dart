import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/data/api/api.dart';

class SubActivityModel {
  final TextEditingController name, total;
  SubActivityModel({required this.name, required this.total});
}

class FormActivityState {
  final List<SubActivityModel> subActivities;

  FormActivityState({this.subActivities = const []});

  FormActivityState copyWith({List<SubActivityModel>? subActivities}) {
    return FormActivityState(
      subActivities: subActivities ?? this.subActivities,
    );
  }
}

class FormActivityNotifier extends StateNotifier<FormActivityState> with Apis {
  FormActivityNotifier() : super(FormActivityState());

  final forms = LzForm.make(['name', 'activity_date', 'description']);

  void addSubActivity() {
    final data = [...state.subActivities];
    data.add(SubActivityModel(name: TextEditingController(), total: TextEditingController()));
    state = state.copyWith(subActivities: data);
  }

  void removeSubActivity(int index) {
    final data = [...state.subActivities];
    data.removeAt(index);
    state = state.copyWith(subActivities: data);
  }

  Future onSubmit() async {
    try {
      final form = forms.validate(
          required: ['*'],
          messages: FormMessages(required: {
            'name': 'Nama kegiatan tidak boleh kosong',
            'activity_date': 'Tanggal kegiatan tidak boleh kosong',
            'description': 'Deskripsi kegiatan tidak boleh kosong'
          }));

      if (!form.ok) {
        return;
      }

      Map<String, dynamic> payload = form.value;
      payload['sub_activities'] = [];

      // add sub_activies if not empty
      if (state.subActivities.isNotEmpty) {
        final subActivities = state.subActivities
            .map((e) => {
                  'name': e.name.text,
                  'total_budget': e.total.text,
                })
            .toList();

        payload['sub_activities'] = subActivities;
      }

      LzToast.overlay('Menambahkan kegiatan...');
      final res = await kegiatanApi.addKegiatan(payload);

      if (!res.status) {
        return LzToast.show(res.message);
      }

      return res.data;
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }
  }
}

final formActivityProvider =
    StateNotifierProvider.autoDispose<FormActivityNotifier, FormActivityState>((ref) => FormActivityNotifier());

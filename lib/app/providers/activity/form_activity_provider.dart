import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/helpers/utils.dart';
import 'package:todo_app/app/data/api/api.dart';

class SubActivityModel {
  final TextEditingController name;
  final TextEditingController total;

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

class FormActivityNotifier extends StateNotifier<FormActivityState> with UseApi {
  FormActivityNotifier() : super(FormActivityState());

  final name = TextEditingController(), activityDate = TextEditingController(), description = TextEditingController();

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
      Map<String, dynamic> payload = {
        'name': name.text,
        'activity_date': activityDate.text,
        'description': description.text,
      };

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

      final res = await kegiatanApi.addKegiatan(payload);
    } catch (e, s) {
      Utils.errorCatcher(e, s);
    }
  }
}

final formActivityProvider =
    StateNotifierProvider.autoDispose<FormActivityNotifier, FormActivityState>((ref) => FormActivityNotifier());

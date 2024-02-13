import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';

class ActivtyDetailNotifier extends StateNotifier<AsyncValue<Kegiatan>> with Apis {
  final String? activityId;
  final name = TextEditingController();
  final activityDate = TextEditingController();
  final description = TextEditingController();

  List fileList = [];
  List<SubActivity2> subActivities = [];
  String userId = '';

  List<Widget> formAmprahan = [];
  List<Widget> formSubKegiatan = [];

  ActivtyDetailNotifier({this.activityId}) : super(const AsyncValue.loading()) {
    if (activityId != '') {
      getActivity();
    }
  }

  Future getActivity() async {
    try {
      state = const AsyncValue.loading();
      final res = await kegiatanApi.getKegiatanById(activityId ?? '');

      if (res.status) {
        final data = res.data['data'];
        name.text = data['name'];
        activityDate.text = data['activity_date'].toString().split(' ')[0];
        description.text = data['description'];

        // set sub activities
        List activities = data['sub_activities'] ?? [];
        subActivities = activities.map((e) {
          return SubActivity2(
            nameController: TextEditingController(text: e['name']),
            totalController: TextEditingController(text: e['total_budget'].toString()),
          );
        }).toList();

        state = AsyncValue.data(Kegiatan.fromJson(data));
      }

      // if (res.statusCode == 200) {
      //   final map = json.decode(res.data);
      //   final data = map['data']['data'];
      //   name.text = data['name'];
      //   activity_date.text = data['activity_date'].toString().split(' ')[0];

      //   description.text = data['description'];
      //   state = AsyncValue.data(Kegiatan.fromJson(data));
      // }
    } catch (e, s) {
      AsyncValue.error(e, s);
    }
  }

  Future createKegiatan(BuildContext context) async {
    try {
      final activies = subActivities.map((e) {
        return {
          "name": e.nameController.text,
          "total_budget": e.totalController.text,
        };
      }).toList();

      final formField = {
        "name": name.value.text,
        "description": description.value.text,
        "activity_date": activityDate.value.text,
        "sub_activities": activies,
        // "created_by": auth.id
      };

      final res = await kegiatanApi.addKegiatan(formField);

      if (res.status) {
        // ignore: use_build_context_synchronously
        context.pop(res.data?['data'] ?? {});

        LzToast.show('Kegiatan berhasil dibuat');
      } else {
        LzToast.show(res.message ?? '');
      }
    } catch (e, s) {
      Errors.check(e, s);
      // state = AsyncValue.error(e, s);
    }
  }

  void addSubActivity() {
    subActivities.add(SubActivity2(nameController: TextEditingController(), totalController: TextEditingController()));
    state = AsyncValue.data(state.value!);
  }

  Future updateActivity(String activityId) async {
    try {
      final activies = subActivities.map((e) {
        return {
          "name": e.nameController.text,
          "total_budget": e.totalController.text,
        };
      }).toList();

      // state = const AsyncValue.loading();
      final fields = {
        "name": name.value.text,
        "activity_date": activityDate.value.text,
        "description": description.value.text,
        "sub_activities": activies,
      };

      final res = await kegiatanApi.updateKegiatan(activityId, fields);

      if (res.status) {
        LzToast.show("update successfully");
        return res.data?['data'] ?? {};
        // update state
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void uploadDoc(BuildContext context) {}
}

final activityDetailProvider =
    StateNotifierProvider.autoDispose.family<ActivtyDetailNotifier, AsyncValue<Kegiatan>, String>((ref, activityId) {
  return ActivtyDetailNotifier(activityId: activityId);
});

import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/screens/home/views/home_page.dart';
import 'package:todo_app/app/screens/login/login_view.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_detail_tata_kelola_screen.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_kegiatan_screen.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_pertanggung_jawaban_screen.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_tata_kelola_screen.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola_screen.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola_user_screen.dart';

import 'helper.dart';
import 'paths.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    Route.set(Paths.home, (state) => const HomePage(), redirect: (_) => _redirect()),
    Route.set(Paths.login, (state) => const LoginView()),
    Route.set(Paths.formTodo, (state) => const ManagementTataKelola()),
    Route.set(Paths.managementTataKelolaDetail(null), (state) => ManagementTataKelolaDetail(params: state.extra)),

    Route.set(Paths.formManagementTataKelola, (state) => const FormTataKelola()),

    GoRoute(
        path: Paths.formPertanggungJawaban,
        builder: (_, GoRouterState state) => FormPertanggungJawaban(kegiatan: state.extra as Kegiatan)),
    GoRoute(
        path: Paths.formManagementTataKelolaDetail,
        builder: (_, GoRouterState state) => FormDetailTataKelola(kegiatan: state.extra as Kegiatan)),

    // management tata kelola
    Route.set(
        Paths.formKegiatan,
        (state) => FormKegiatanScreen(
              kegiatan: state.extra as Kegiatan,
            )),
  ],
);

Future<String> _redirect() async {
  String? token = prefs.getString('token');

  if (token == null) {
    return Paths.login;
  } else {
    GetAuh getAuth = GetAuh();
    final res = await getAuth.getAuth(token);
    if (res) {
      return Paths.home;
    } else {
      // Toasts.show('Authentication failed');
      // Handle the case where getAuth returned false
      // print('Authentication failed');
      return Paths.login;
    }
  }
}

class GetAuh with UseApi {
  Future getAuth(String token) async {
    try {
      String? authString = (prefs.getString('auth') ?? '');
      // final auth = json.decode(authString);
      if (authString != '') {
        final res = await authApi.getAuth();

        final userString = json.decode(res.data);
        prefs.setString('auth', json.encode(userString['data']));
        return true;
      } else {
        print('User id not found');
        return false;
      }
    } catch (e, s) {
      print('Error: $e, StackTrace: $s');
      return false;
    }
  }
}

import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/screens/home/views/home_page.dart';
import 'package:todo_app/app/screens/login/login_view.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_pertanggung_jawaban.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/form_tata_kelola.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola_detail.dart';

import 'helper.dart';
import 'paths.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    Route.set(Paths.home, (state) => const HomePage(),
        redirect: (_) => _redirect()),
    Route.set(Paths.login, (state) => const LoginView()),
    Route.set(Paths.formTodo, (state) => ManagementTataKelola()),
    Route.set(Paths.managementTataKelolaDetail(null),
        (state) => ManagementTataKelolaDetail(params: state.extra)),
    Route.set(Paths.formManagementTataKelola, (state) => FormTataKelola()),
    Route.set(
        Paths.formPertanggungJawaban, (state) => FormPertanggungJawaban()),
  ],
);

Future<String> _redirect() async {
  String? token = prefs.getString('token');

  if (token == null) {
    return Paths.login;
  } else {
    GetAuh getAuth = GetAuh();
    final res = await getAuth.getAuth(token);
    print(res);
    if (res) {
      return Paths.home;
    } else {
      // Toasts.show('Authentication failed');
      // Handle the case where getAuth returned false
      print('Authentication failed');
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
        final authJson = json.decode(authString);
        final res = await authApi.getAuth(authJson['id']);
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

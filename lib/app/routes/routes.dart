import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/screens/home/views/home_page.dart';
import 'package:todo_app/app/screens/login/login_view.dart';
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
      // Handle the case where getAuth returned false
      print('Authentication failed');
      return Paths.login;
    }
  }
}

class GetAuh with UseApi {
  Future getAuth(String token) async {
    try {
      String? auth = (prefs.getString('auth') ?? '');
      if (auth != '') {
        final authJson = json.decode(auth);
        final res = await authApi.getAuth(authJson['id']);
        prefs.setString('auth', res.data);
      } else {
        print('User id not found');
      }

      return true;
    } catch (e, s) {
      print('Error: $e, StackTrace: $s');
      return false;
    }
  }
}

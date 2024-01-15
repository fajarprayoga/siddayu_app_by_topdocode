import 'package:go_router/go_router.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/data/models/user/user.dart';
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
    Route.set(Paths.managementTataKelolaDetail, (state) => ManagementTataKelolaDetail(data: state.extra as User)),
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

String _redirect() {
  String? token = prefs.getString('token');
  return token == null ? Paths.login : Paths.home;
}

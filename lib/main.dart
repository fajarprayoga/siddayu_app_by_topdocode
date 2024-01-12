import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/core/extensions/dio_extension.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

import 'app/core/constants/theme.dart';
import 'app/routes/routes.dart';

void main() async {
  // init flutter, to make sure all the widgets are ready
  WidgetsFlutterBinding.ensureInitialized();

  // init lazyui
  // LazyUi.config(alwaysPortrait: true);

  // init shared preferences
  prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  dio.setToken(token);

  // init dio, we customize it with the name "fetchly"
  // Fetchly.init(
  //     baseUrl: 'https://api.igsa.pw/api/',
  //     onRequest: RequestHandler.onRequest);

  // NOTE: kamu juga bisa membuat file sendiri untuk menjalankan kode pada bagian ini
  // sehingga file main.dart ini terlihat lebih bersih

  // config status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white));

  // init provider and run app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Todo App',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router);
  }
}

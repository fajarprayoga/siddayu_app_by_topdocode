import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

import 'app/core/constants/theme.dart';
import 'app/core/constants/value.dart';
import 'app/core/helpers/request_handler.dart';
import 'app/routes/routes.dart';

void main() async {
  // init flutter, to make sure all the widgets are ready
  WidgetsFlutterBinding.ensureInitialized();

  // init lazyui
  LazyUi.config(alwaysPortrait: true);
  Errors.config(botToken: botToken, chatId: chatId);

  // init shared preferences
  prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // init dio, we customize it with the name "fetchly"
  Fetchly.init(
      baseUrl: 'https://topdocode.sidayu.com/api/',
      onRequest: RequestHandler.onRequest,
      onError: RequestHandler.onError,
      printType: PrintType.log);
  dio.setToken(token);

  // init toast
  LzToast.config(position: Position.center);

  // init provider and run app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Siddayu App',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (BuildContext context, Widget? child) {
          return LazyUi.builder(context, child);
        });
  }
}

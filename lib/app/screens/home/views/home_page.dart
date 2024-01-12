// this base for routes
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/constants/pages.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/data/models/auth.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
// import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/providers/app_provider.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/routes/routes.dart';

class HomePage extends ConsumerWidget {
  // final User user;

  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // prefs.remove('token');
    final notifier = ref.watch(appStateProvider);

    // get data auth

    String? authLocal = prefs.getString('auth');

    final auth = Auth.fromJson(json.decode(authLocal ?? ''));

    // final User user;
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(235, 244, 245, 1),
                Color.fromRGBO(254, 253, 253, 1),
              ])),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => {},
                      child: const Icon(
                        Icons.arrow_back,
                        size: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(1, 2))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(auth.name),
                                Text(
                                  auth.email,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: gap * 3,
              ),
              // List Generate Menu
              ...List.generate(pages.length, (i) {
                return ListTile(
                  title: Row(
                    children: [
                      Icon(pages[i]['icon']),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        pages[i]['title'],
                        style: TextStyle(
                            fontWeight: notifier.page == i
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                  onTap: () {
                    final notifier = ref.read(appStateProvider.notifier);
                    // Tindakan yang diambil saat ListTile ditekan
                    notifier.navigateTo(i);
                    Navigator.pop(context);
                  },
                  tileColor: notifier.page == i ? Colors.red : null,
                  selected: notifier.page == i,
                  selectedColor: notifier.page == i
                      ? Colors.lightBlueAccent[300]
                      : Colors.black,
                );
              }),
              ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () {
                  // Tindakan yang diambil saat Logout ditekan
                  prefs.remove('token');
                  prefs.remove('auth');
                  Navigator.pop(context); // Tutup Drawer setelah Logout
                  router.push(Paths.login);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pages[notifier.page]['title'],
              style: Gfont.bold.fsize(18),
            ),
          ],
        ),
        // backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: pages[notifier.page]['page']),
    );
  }
}

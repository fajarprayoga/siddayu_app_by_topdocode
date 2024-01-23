import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/pages.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/providers/app_provider.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/routes/routes.dart';

import '../../../data/service/local/auth.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appStateProvider.notifier);

    // final User user;
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(0))),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Color.fromRGBO(235, 244, 245, 1),
            Color.fromRGBO(254, 253, 253, 1),
          ])),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: BounceScroll(),
            children: <Widget>[
              Container(
                width: context.width,
                padding: Ei.only(t: context.viewPadding.top + 20, others: 20),
                child: FutureBuilder(
                    future: Auth.user(),
                    builder: (_, snap) {
                      final auth = snap.data;
                      String name = auth?.name ?? '-';
                      String email = auth?.email ?? '-';
                      return Column(
                        children: [
                          const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                              child: Icon(Ti.user),
                            ),
                          ),
                          Textr(
                            name,
                            overflow: Tof.ellipsis,
                            margin: Ei.only(t: 15),
                          ),
                          Text(
                            email,
                            overflow: Tof.ellipsis,
                            style: Gfont.muted,
                          ),
                        ],
                      ).start;
                    }),
              ),

              // List Generate Menu
              ...List.generate(pages.length, (i) {
                String title = pages[i]['title'];
                IconData? icon = pages[i]['icon'];

                return InkTouch(
                  onTap: () {
                    final page = pages[i]['page'];

                    if (page != '') {
                      notifier.navigateTo(i);
                      context.pop();
                    } else {
                      // logout
                      LzConfirm(
                        title: 'Logout',
                        message: 'Apakah Anda yakin ingin keluar dari aplikasi ini?',
                        onConfirm: () {
                          notifier.logout();

                          context.pop();
                          router.push(Paths.login);
                        },
                      ).show(context);
                    }
                  },
                  padding: Ei.all(20),
                  border: Br.only(['t'], except: i == 0),
                  child: Textr(title, icon: icon),
                );
              })
            ],
          ),
        ),
      ),
      appBar: AppBar(title: appStateProvider.watch(
        (state) {
          String title = pages[state.page]['title'];

          return Text(
            title,
            style: Gfont.fs18.bold,
          );
        },
      )),
      body: appStateProvider.watch((state) => pages[state.page]['page']),
    );
  }
}

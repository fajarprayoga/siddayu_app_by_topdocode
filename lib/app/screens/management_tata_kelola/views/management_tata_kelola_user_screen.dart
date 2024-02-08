import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/data/models/user/user.dart';
import 'package:todo_app/app/providers/activity/activity_user_provider.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/widgets/custom_appbar.dart';

class ManagementTataKelolaDetail extends ConsumerWidget {
  final User data;
  const ManagementTataKelolaDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String id = data.id.toString();

    final activityProvider = ref.watch(activityUserProvider(id));
    final notifier = ref.read(activityUserProvider(id).notifier);

    final activities = activityProvider.activities;

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppbar(title: 'Management Tata Kelola', subtitle: 'Kegiatan'),
      ),
      body: activities.when(
          data: (activities) {
            if (activities.isEmpty) {
              return LzNoData(message: 'Tidak ada data', onTap: () => notifier.getKegiatan());
            }

            return Refreshtor(
                onRefresh: () async => notifier.getKegiatan(),
                child: LzListView(
                  onScroll: (scroller) {
                    if ((scroller.position.pixels + 100) >= scroller.position.maxScrollExtent) {
                      if (notifier.isPaginate || notifier.isAllReaches) return;
                      notifier.onGetMore();
                    }
                  },
                  children: [
                    Column(
                      children: activities.generate((item, i) {
                        final ikey = GlobalKey();

                        return InkTouch(
                          onTap: () async {
                            List<String> options = ['Edit', 'Detail', 'Hapus'];
                            int danger = options.indexOf('Hapus');

                            DropX.show(ikey, options: options.options(dangers: [danger]), onSelect: (value) {
                              if (value.option == 'Edit') {
                                context.push(Paths.formManagementTataKelola, extra: item).then((value) {
                                  if (value != null) {
                                    value as Map<String, dynamic>;
                                    notifier.updateData(Kegiatan.fromJson(value));
                                  }
                                });
                              } else if (value.option == 'Detail') {
                                context.push(Paths.asset, extra: item);
                              } else if (value.option == 'Hapus') {
                                LzConfirm(
                                  title: 'Hapus Data',
                                  message: 'Apakah anda yakin ingin menghapus data kegiatan ini?',
                                  onConfirm: () {
                                    notifier.deleteData(item.id!);
                                  },
                                ).show(context);
                              }
                            });
                          },
                          padding: Ei.all(20),
                          border: Br.only(['t'], except: i == 0),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: Maa.spaceBetween,
                            children: [
                              // Textr(item.createdBy ?? ''),
                              Textr(
                                (item.name ?? '-').ucwords,
                                icon: Ti.list,
                                margin: Ei.only(r: 15),
                              ).lz.flexible(),
                              Icon(
                                Ti.dots,
                                key: ikey,
                              )
                            ],
                          ),
                        );
                      }),
                    ),

                    // pagination loading
                    activityUserProvider(id).watch((state) {
                      return state.isPaginating ? LzLoader.bar() : const SizedBox();
                    })
                  ],
                ));
          },
          error: (e, s) => LzNoData(
                message: 'Error on: $e, $s',
              ),
          loading: () => LzLoader.bar(message: 'Loading data...')),

      // add new activity
      floatingActionButton: notifier.isUserLogged
          ? FloatingActionButton(
              onPressed: () {
                context.push(Paths.formManagementTataKelola).then((value) {
                  if (value != null) {
                    value as Map<String, dynamic>;
                    notifier.addData(Kegiatan.fromJson(value));
                  }
                });
              },
              child: const Icon(Ti.plus),
            )
          : const None(),
    );
  }
}

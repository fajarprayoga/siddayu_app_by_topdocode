import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/data/models/user/user.dart';
import 'package:todo_app/app/providers/activity/activity_provider.dart';
import 'package:todo_app/app/providers/user/user_provider.dart';
import 'package:todo_app/app/routes/paths.dart';

class ManagementTataKelola extends ConsumerWidget {
  const ManagementTataKelola({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProviderData = ref.watch(userProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Refreshtor(
          onRefresh: () async {
            ref.read(userProvider.notifier).getStaffUsers();
            ref.read(activityProvider.notifier).getKegiatan();
          },
          child: LzListView(
            children: [
              // list of users
              userProviderData.when(
                  data: (users) => StaffBoxWidget(users),
                  error: (e, s) => Center(child: Text('Error: $e $s')),
                  loading: () => StaffBoxWidget(const [], loadingMode: LoadingMode(6))),

              // list of activities
              activityProvider.watch((state) {
                bool isUpdating = state.isUpdating;

                return state.activities.when(
                    data: (activities) {
                      return Container(
                        padding: Ei.all(20),
                        margin: Ei.only(t: 15),
                        decoration: BoxDecoration(
                            color: Colors.white, border: Br.all(color: Colors.black38), borderRadius: Br.radius(8)),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: Maa.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Progress Kegiatan',
                                    style: Gfont.bold,
                                  ),
                                  if (isUpdating) Text('Updating...', style: Gfont.fs14).lz.blink()
                                ],
                              ).start,
                              InkTouch(
                                onTap: () {
                                  context.push(Paths.allActivities).then((value) {
                                    ref.read(activityProvider.notifier).updateActivityProgress();
                                  });
                                },
                                padding: Ei.sym(v: 10, h: 20),
                                border: Br.all(color: Colors.black38),
                                radius: Br.radius(8),
                                child: const Textr(
                                  'All',
                                  icon: Ti.chevronRight,
                                  iconStyle: IconStyle(asSuffix: true),
                                ),
                              ),
                            ],
                          ),
                          ...activities.generate((item, i) {
                            return ActivityProgress(item);
                          }),
                        ]),
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () => LzLoader.bar());
              }),
            ],
          ),
        ));
  }
}

class ActivityProgress extends ConsumerWidget {
  final Kegiatan data;
  const ActivityProgress(this.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String name = data.name ?? '-';
    double progress = double.tryParse(data.progress.toString()) ?? 0;
    progress = context.width * (progress / 100);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: padding),
      child: InkWell(
        onTap: () {
          context.push(Paths.formManagementTataKelola, extra: data).then((value) {
            ref.read(activityProvider.notifier).updateActivityProgress();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Textr(name, margin: Ei.only(b: gap)),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
                  height: 21,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  width: progress,
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoadingMode {
  final int length;
  LoadingMode(this.length);
}

class StaffBoxWidget extends ConsumerWidget {
  final List<User> users;
  final LoadingMode? loadingMode;
  const StaffBoxWidget(this.users, {super.key, this.loadingMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoadingMode = loadingMode != null;

    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: (isLoadingMode ? loadingMode!.length.generate((item) => User()) : users).generate((item, i) {
          String name = item.name ?? '-';
          double width = (context.width / 2) - 25;

          if (isLoadingMode) {
            return Skeleton(
              size: [width, 60],
              radius: 8,
            );
          }

          return InkTouch(
            onTap: () {
              context.push(Paths.managementTataKelolaDetail, extra: item).then((value) {
                ref.read(activityProvider.notifier).updateActivityProgress();
              });
            },
            color: const Color.fromARGB(255, 251, 224, 91),
            radius: Br.radius(8),
            child: Container(
              width: width,
              padding: Ei.all(10),
              child: Row(
                mainAxisSize: Mas.min,
                children: [
                  LzImage(item.profilePicture ?? 'user.jpeg', size: 50, radius: 100).margin(r: 10),
                  Text(name.ucwords).lz.flexible()
                ],
              ),
            ),
          ).lz.clip(all: 8);
        }));
  }
}

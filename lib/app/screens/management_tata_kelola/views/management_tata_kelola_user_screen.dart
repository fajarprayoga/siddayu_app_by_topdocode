import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppbar(title: 'Management Tata Kelola', subtitle: 'Kegiatan'),
      ),
      body: activityProvider.when(
          data: (activities) {
            if (activities.isEmpty) {
              return LzNoData(message: 'Tidak ada data', onTap: () => notifier.getKegiatan());
            }

            return Refreshtor(
                onRefresh: () async => notifier.getKegiatan(),
                child: LzListView(
                  children: [
                    // if (notifier.isUserLogged)
                    //   Row(
                    //     children: [
                    //       PrimaryButton(
                    //         'Tambah Kegiatan',
                    //         icon: Ti.plus,
                    //         onTap: () {
                    //           context.push(Paths.formManagementTataKelola).then((value) {
                    //             value as Map<String, dynamic>;
                    //             notifier.addData(Kegiatan.fromJson(value));
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ).end,

                    // list of activities
                    Column(
                      children: activities.generate((item, i) {
                        final ikey = GlobalKey();

                        return InkTouch(
                          onTap: () {
                            DropX.show(ikey, options: ['Edit', 'Detail', 'Hapus'].options(dangers: [2]),
                                onSelect: (value) {
                              if (value.index == 0) {
                                context.push(Paths.formManagementTataKelola, extra: item).then((value) {
                                  if (value != null) {
                                    value as Map<String, dynamic>;
                                    notifier.updateData(Kegiatan.fromJson(value));
                                  }
                                });
                              } else if (value.index == 1) {
                                logg('halo');
                              } else if (value.index == 2) {
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
                    )
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

// class ListKegiatan extends StatelessWidget {
//   final Kegiatan item;
//   final ActivityUserNotifier notifier;
//   const ListKegiatan({Key? key, required this.item, required this.notifier}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       margin: const EdgeInsets.symmetric(vertical: marginVertical),
//       padding: const EdgeInsets.all(padding),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//       child: InkWell(
//         onTap: () {
//           context.push(Paths.formManagementTataKelolaDetail, extra: item).then((value) {
//             value as Map<String, dynamic>;
//             notifier.updateData(Kegiatan.fromJson(value));
//           });
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   const Icon(Icons.list),
//                   const SizedBox(
//                     width: gap,
//                   ),
//                   Flexible(
//                     child: Text(
//                       item.name,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.arrow_right,
//               color: primary,
//               size: 24,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ButtonAddKegiatan extends StatelessWidget {
//   final ActivityUserNotifier notifier;
//   final Function()? onTap;

//   const ButtonAddKegiatan({super.key, required this.notifier, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.centerRight,
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(radius - 10),
//             color: primary,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 "Tambah Kegiatan",
//                 style: Gfont.white,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

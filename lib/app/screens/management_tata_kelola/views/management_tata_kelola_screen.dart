import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
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
    final activityProviderData = ref.watch(activityProvider);

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
              activityProviderData.when(
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
                            Text(
                              'Progress Kegiatan',
                              style: Gfont.bold,
                            ),
                            InkTouch(
                              onTap: () {},
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
                  loading: () => LzLoader.bar())
            ],
          ),
        )

        // RefreshIndicator(
        //   onRefresh: () async {
        //     // await ref.read(userProvider.notifier).getStaffUsers();
        //     // await ref.read(kegiatanProvider.notifier).getKegiatan();
        //   },
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Center(
        //         child: userProviderData.when(
        //             data: (userData) {
        //               return Wrap(
        //                 spacing: 10,
        //                 runSpacing: 10,
        //                 alignment: WrapAlignment.center,
        //                 crossAxisAlignment: WrapCrossAlignment.center,
        //                 children: List.generate(
        //                   userData.length,
        //                   (index) => BoxStaff(
        //                     name: userData[index].name ?? '',
        //                     image: userData[index].profilePicture ?? '',
        //                     id: userData[index].id ?? '',
        //                   ),
        //                 ),
        //               );
        //             },
        //             error: (error, stackTrace) => Text('Error: $error'),
        //             loading: () => BoxStaffPlaceholder()),
        //       ),
        // SizedBox(height: 20),
        // activityProviderData.when(
        //     data: (kegiatanData) {
        //       return Expanded(
        //         child: Padding(
        //           padding: EdgeInsets.only(bottom: 20),
        //           child: Container(
        //             width: MediaQuery.of(context).size.width * 0.9,
        //             padding: EdgeInsets.all(padding),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(5),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.blueGrey,
        //                   blurRadius: 4,
        //                   offset: Offset(0, 1), // Posisi bayangan
        //                 ),
        //               ],
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text(
        //                       'Progress Kegiatan',
        //                       style: TextStyle(fontWeight: FontWeight.bold),
        //                     ),
        //                     InkWell(
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text("All"),
        //                           Icon(
        //                             Icons.arrow_right,
        //                             size: 36,
        //                           )
        //                         ],
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //                 SizedBox(height: gap),
        //                 Expanded(
        //                   child: ListView.builder(
        //                     itemCount: kegiatanData.length,
        //                     itemBuilder: (BuildContext context, int index) {
        //                       return KegiatanProgress(
        //                           name: kegiatanData[index].name, progress: (kegiatanData[index].progress));
        //                     },
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //     error: (error, stackTrace) => Text('Error: $error'),
        //     loading: () => ProgressKegiatanPlaceholder())
        //     ],
        //   ),
        // )

        );
  }
}

class ActivityProgress extends StatelessWidget {
  final Kegiatan data;
  const ActivityProgress(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? '-';
    double progress = double.tryParse(data.progress ?? '0') ?? 0;
    progress = context.width * (progress / 100);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: padding),
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
    );
  }
}

// class KegiatanProgress extends StatefulWidget {
//   final String name;
//   final double progress;
//   const KegiatanProgress({
//     Key? key,
//     required this.name,
//     required this.progress,
//   }) : super(key: key);

//   @override
//   State<KegiatanProgress> createState() => _KegiatanProgressState();
// }

// class _KegiatanProgressState extends State<KegiatanProgress> {
//   double _width = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Memanggil setState setelah frame saat ini selesai diproses
//       setState(() {
//         _width = MediaQuery.of(context).size.width * (widget.progress / 100);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: padding),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(widget.name),
//           SizedBox(
//             height: gap,
//           ),
//           Stack(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
//                 height: 21,
//               ),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 800),
//                 width: _width,
//                 decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
//                 height: 21,
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class LoadingMode {
  final int length;
  LoadingMode(this.length);
}

class StaffBoxWidget extends StatelessWidget {
  final List<User> users;
  final LoadingMode? loadingMode;
  const StaffBoxWidget(this.users, {super.key, this.loadingMode});

  @override
  Widget build(BuildContext context) {
    bool isLoadingMode = loadingMode != null;

    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
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
              context.push(Paths.managementTataKelolaDetail, extra: item);
            },
            color: const Color.fromARGB(255, 251, 224, 91),
            radius: Br.radius(8),
            child: Container(
              width: width,
              padding: Ei.all(10),
              child: Row(
                mainAxisSize: Mas.min,
                children: [
                  const LzImage('user.jpeg', size: 50, radius: 100).margin(r: 10),
                  Text(name.ucwords).lz.flexible()
                ],
              ),
            ),
          ).lz.clip(all: 8);
        }));
  }
}

// class BoxStaff extends StatefulWidget {
//   final String name;
//   final String image;
//   final String id;
//   const BoxStaff({
//     Key? key,
//     required this.name,
//     required this.image,
//     required this.id,
//   }) : super(key: key);

//   @override
//   State<BoxStaff> createState() => _BoxStaffState();
// }

// class _BoxStaffState extends State<BoxStaff> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // context.push(Paths.managementTataKelolaDetail('1'), extra: {'id': widget.id, 'name': widget.name});
//       },
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 800),
//         opacity: 1,
//         child: Container(
//           height: 68,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 251, 224, 91)),
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           width: (MediaQuery.of(context).size.width / 2) - 40,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/user.jpeg'),
//                       fit: BoxFit.cover,
//                     )),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: Text(
//                   widget.name,
//                   style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

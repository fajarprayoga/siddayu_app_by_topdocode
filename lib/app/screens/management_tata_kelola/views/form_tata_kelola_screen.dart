import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/core/extensions/widget_extension.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/data/service/local/trainer.dart';
import 'package:todo_app/app/providers/activity/form_activity_provider.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/widgets/custom_appbar.dart';

import '../../../widgets/custom_textfield.dart';

class FormTataKelola extends ConsumerWidget {
  final Kegiatan? data;
  const FormTataKelola({super.key, this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ikey = GlobalKey();
    final notifier = ref.read(formActivityProvider.notifier);
    final forms = notifier.forms;

    String sub = data == null ? 'Create' : 'Edit';

    if (data != null) {
      notifier.initForm(data!);
    }

    return AppTrainer(
      targets: [
        Target(
            key: ikey,
            title: 'Pertanggung Jawaban',
            description: 'Klik icon ini untuk melihat atau menambahkan pertanggung jawaban.')
      ],
      showOnInit: false,
      onInit: (control) {
        if (data != null && !Trainer.get(TType.activity)) {
          control.show();
          Trainer.set(TType.activity);
        }
      },
      showSectionLabel: true,
      finishLabel: 'Tutup',
      child: Wrapper(
        child: Scaffold(
          appBar: AppBar(
            title: CustomAppbar(
              title: 'Management Tata Kelola',
              subtitle: 'Kegiatan / $sub',
            ),
            actions: [
              Icon(Ti.clipboardCheck, key: ikey)
                  .onPressed(() {
                    context.push(Paths.formKegiatan, extra: data);
                  })
                  .lz
                  .hide(data == null)
            ],
          ),

          body: LzFormList(
            style: const LzFormStyle(type: FormType.topAligned, inputBorderColor: Colors.black38),
            children: [
              LzForm.input(
                label: 'Nama Kegiatan',
                hint: 'Masukan nama kegiatan',
                model: forms['name'],
              ),
              LzForm.input(
                  label: 'Tanggal Kegiatan',
                  hint: 'Masukan tanggal kegiatan',
                  suffixIcon: Ti.calendar,
                  model: forms['activity_date'],
                  onTap: (control) {
                    LzPicker.datePicker(context).then((value) {
                      control.text = value.format();
                    });
                  }),
              LzForm.input(
                label: 'Deskripsi Kegiatan',
                hint: 'Masukan deskripsi kegiatan',
                maxLines: 5,
                maxLength: 500,
                model: forms['description'],
              ),

              // sub activities
              formActivityProvider.watch((state) {
                if (state.subActivities.isEmpty) {
                  return const SizedBox();
                }

                return Column(children: [
                  Textr('Sub Kegiatan', style: Gfont.bold, margin: Ei.only(t: 15, b: 10)),
                  ...state.subActivities.generate((item, i) {
                    return SlideUp(
                      child: Row(
                        children: [
                          Expanded(child: CustomTextfield(hint: 'Sub kegiatan', controller: item.name)),
                          CustomTextfield(hint: '0', controller: item.total, keyboard: Tit.number)
                              .sized(width: 100)
                              .margin(h: 5),
                          Iconr(
                            Ti.x,
                            color: Colors.red,
                            padding: Ei.only(l: 5, v: 10),
                          ).onTap(() {
                            notifier.removeSubActivity(i);
                          }),
                        ],
                      ).margin(b: 5),
                    );
                  })
                ]).start;
              }),
              Textr(
                'Tambah Sub Kegiatan',
                icon: Ti.plus,
                style: Gfont.bold,
                padding: Ei.sym(v: 10),
              ).onTap(() => notifier.addSubActivity())
            ],
          ),

          bottomNavigationBar: LzButton(
            text: data == null ? 'Simpan' : 'Perbarui',
            color: primary,
            textColor: Colors.white,
            onTap: (_) async {
              final res = await notifier.onSubmit(data?.id);
              if (res != null && context.mounted) {
                context.pop(res?['data'] ?? {});
              }
            },
          ).theme1(),

          // body: SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: padding),
          //     child: Container(
          //       margin: const EdgeInsets.only(top: gap + 20),
          //       padding: const EdgeInsets.symmetric(horizontal: padding + 10),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // Row(
          //           //   mainAxisAlignment: Maa.end,
          //           //   children: [
          //           //     PrimaryButton('Pertanggung Jawaban', onTap: () {
          //           //       context.push(Paths.formKegiatan);
          //           //     }),
          //           //   ],
          //           // ),

          //           FormFieldCustom(
          //             title: 'Nama Kegiatan',
          //             placeholder: 'Masukan nama kegiatan',
          //             controller: notifier.name,
          //           ),
          //           FormFieldCustom(
          //               title: 'Tanggal Kegiatan',
          //               placeholder: 'Masukan tanggal kegiatan',
          //               icon: Icons.date_range,
          //               controller: notifier.activityDate,
          //               type: 'DATE'),
          //           FormFieldCustom(
          //             title: 'Deskripsi Kegiatan',
          //             placeholder: 'Masukan deskripsi kegiatan',
          //             isMultiLine: true,
          //             controller: notifier.description,
          //           ),

          //           formActivityProvider.watch((state) {
          //             return Column(
          //               children: state.subActivities.generate((item, i) {
          //                 // return notifier.subActivities[i];
          //                 return Row(
          //                   // mainAxisAlignment: MainAxisAlignment.end,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     Expanded(
          //                       child: FormFieldCustom(
          //                         title: '',
          //                         placeholder: 'Sub Kegiatan',
          //                         controller: item.name,
          //                         // onChanged: (value) {
          //                         //   if (index < subActivities.length) {
          //                         //     subActivities[index] = {...subActivities[index], "name": value};
          //                         //   } else {
          //                         //     subActivities.add({"name": value});
          //                         //   }
          //                         // },
          //                       ),
          //                     ),
          //                     const SizedBox(
          //                       width: gap,
          //                     ),
          //                     FormFieldCustom(
          //                       width: 100,
          //                       title: '',
          //                       placeholder: '0',
          //                       keyboardType: TextInputType.number,
          //                       controller: item.total,
          //                       onChanged: (value) {
          //                         // print(index);
          //                         // if (index < subActivities.length) {
          //                         //   subActivities[index] = {...subActivities[index], "total_budget": value};
          //                         // } else {
          //                         //   subActivities.add({"total_budget": value});
          //                         // }
          //                       },
          //                     ),
          //                     Center(
          //                         child: InkWell(
          //                             onTap: () {
          //                               notifier.removeSubActivity(i);
          //                             },
          //                             child: Icon(
          //                               Icons.delete,
          //                               size: 32,
          //                               color: Colors.red[800],
          //                             )))
          //                   ],
          //                 );
          //               }),
          //             );
          //           }),

          //           // if (formSubKegiatan.isNotEmpty)
          //           //   ListView.builder(
          //           //     physics: const NeverScrollableScrollPhysics(),
          //           //     itemCount: formSubKegiatan.length,
          //           //     shrinkWrap: true,
          //           //     itemBuilder: (context, index) {
          //           //       return formSubKegiatan[index];
          //           //     },
          //           //   ),

          //           ElevatedButton.icon(
          //             onPressed: () {
          //               notifier.addSubActivity();
          //             },
          //             icon: const Icon(Icons.add),
          //             label: const Text('Tambah Sub Kegiatan'),
          //             style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          //           ),
          //           const SizedBox(
          //             height: gap + 10,
          //           ),
          //           InkWell(
          //             onTap: () async {
          //               notifier.onSubmit();
          //               // _showFullModal(context);
          //               // await notifier.createKegiatan(context);
          //               // context.pop();
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(radius - 10),
          //                 color: primary,
          //               ),
          //               padding: const EdgeInsets.all(padding),
          //               child: Text(
          //                 'Simpan',
          //                 style: Gfont.fs14.white,
          //               ),
          //             ),
          //           )
          //           // Checkbox(value: true, onChanged: (){})
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

// class FormTataKelola extends ConsumerStatefulWidget {
//   const FormTataKelola({
//     super.key,
//   });

//   @override
//   ConsumerState<FormTataKelola> createState() => _FormTataKelolaState();
// }

// class _FormTataKelolaState extends ConsumerState<FormTataKelola> {
//   List<Widget> formAmprahan = [];
//   List<Widget> formSubKegiatan = [];

//   @override
//   Widget build(BuildContext context) {
//     final notifier = ref.read(activityDetailProvider('').notifier);
//     // notifier.name.clear();
//     // notifier.activity_date.clear();
//     // notifier.description.clear();
//     // List<Widget> formSubKegiatan = [];
//     // formSubKegiatan.clear();

//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         systemNavigationBarIconBrightness: Brightness.dark,
//         statusBarIconBrightness: Brightness.dark,
//         statusBarColor: Colors.transparent,
//         systemNavigationBarColor: Colors.white));

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Management Tata Kelola ",
//                 style: Gfont.bold,
//               ),
//               Text(
//                 "Kegiatan / Detail / Create",
//                 style: Gfont.fs14,
//               )
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: padding),
//             child: Container(
//               margin: const EdgeInsets.only(top: gap + 20),
//               padding: const EdgeInsets.symmetric(horizontal: padding + 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: Maa.end,
//                     children: [
//                       PrimaryButton('Pertanggung Jawaban', onTap: () {
//                         context.push(Paths.formKegiatan);
//                       }),
//                     ],
//                   ),

//                   FormFieldCustom(
//                     title: 'Nama Kegiatan',
//                     placeholder: 'Masukan nama kegiatan',
//                     controller: notifier.name,
//                   ),
//                   FormFieldCustom(
//                       title: 'Tanggal Kegiatan',
//                       placeholder: 'Masukan tanggal kegiatan',
//                       icon: Icons.date_range,
//                       controller: notifier.activity_date,
//                       type: 'DATE'),
//                   FormFieldCustom(
//                     title: 'Deskripsi Kegiatan',
//                     placeholder: 'Masukan deskripsi kegiatan',
//                     isMultiLine: true,
//                     controller: notifier.description,
//                   ),

//                   if (formSubKegiatan.isNotEmpty)
//                     ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: formSubKegiatan.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return formSubKegiatan[index];
//                       },
//                     ),

//                   ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         // formSubKegiatan.add(subKegiatan(null));
//                         formSubKegiatan.add(subKegiatan((formSubKegiatan.length), notifier.subActivities));
//                       });
//                     },
//                     icon: const Icon(Icons.add),
//                     label: const Text('Tambah Sub Kegiatan'),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
//                   ),
//                   const SizedBox(
//                     height: gap + 10,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       // _showFullModal(context);
//                       await notifier.createKegiatan(context);
//                       // context.pop();
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(radius - 10),
//                         color: primary,
//                       ),
//                       padding: const EdgeInsets.all(padding),
//                       child: Text(
//                         'Simpan',
//                         style: Gfont.fs14.white,
//                       ),
//                     ),
//                   )
//                   // Checkbox(value: true, onChanged: (){})
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Row subKegiatan(int index, List subActivities) {
//     final name = TextEditingController();
//     final total = TextEditingController();
//     return Row(
//       // mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Expanded(
//           child: FormFieldCustom(
//             title: '',
//             placeholder: 'Sub Kegiatan',
//             controller: name,
//             onChanged: (value) {
//               if (index < subActivities.length) {
//                 subActivities[index] = {...subActivities[index], "name": value};
//               } else {
//                 subActivities.add({"name": value});
//               }
//             },
//           ),
//         ),
//         const SizedBox(
//           width: gap,
//         ),
//         FormFieldCustom(
//           width: 100,
//           title: '',
//           placeholder: '0',
//           keyboardType: TextInputType.number,
//           controller: total,
//           onChanged: (value) {
//             // print(index);
//             if (index < subActivities.length) {
//               subActivities[index] = {...subActivities[index], "total_budget": value};
//             } else {
//               subActivities.add({"total_budget": value});
//             }
//           },
//         ),
//         Center(
//             child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     formSubKegiatan.removeAt(index);
//                   });
//                 },
//                 child: Icon(
//                   Icons.delete,
//                   size: 32,
//                   color: Colors.red[800],
//                 )))
//       ],
//     );
//   }

//   // _showFullModal(context) {
//   //   showGeneralDialog(
//   //     context: context,
//   //     barrierDismissible:
//   //         false, // should dialog be dismissed when tapped outside
//   //     barrierLabel: "Modal", // label for barrier
//   //     transitionDuration: Duration(
//   //         milliseconds:
//   //             500), // how long it takes to popup dialog after button click
//   //     pageBuilder: (_, __, ___) {
//   //       // your widget implementation
//   //       return Scaffold(
//   //         appBar: AppBar(
//   //             backgroundColor: Colors.white,
//   //             centerTitle: true,
//   //             leading: IconButton(
//   //                 icon: Icon(
//   //                   Icons.close,
//   //                   color: Colors.black,
//   //                 ),
//   //                 onPressed: () {
//   //                   Navigator.pop(context);
//   //                 }),
//   //             title: Text(
//   //               "Modal",
//   //               style: TextStyle(
//   //                   color: Colors.black87,
//   //                   fontFamily: 'Overpass',
//   //                   fontSize: 20),
//   //             ),
//   //             elevation: 0.0),
//   //         backgroundColor: Colors.white,
//   //         body: Container(
//   //           padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//   //           decoration: BoxDecoration(
//   //             border: Border(
//   //               top: BorderSide(
//   //                 color: const Color(0xfff8f8f8),
//   //                 width: 1,
//   //               ),
//   //             ),
//   //           ),
//   //           child: SingleChildScrollView(
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 RichText(
//   //                   textAlign: TextAlign.justify,
//   //                   text: TextSpan(
//   //                       text:
//   //                           "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
//   //                       style: TextStyle(
//   //                           fontWeight: FontWeight.w400,
//   //                           fontSize: 14,
//   //                           color: Colors.black,
//   //                           wordSpacing: 1)),
//   //                 ),
//   //                 SizedBox(
//   //                   height: 10,
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

// enum Type { date, text }

// class FormFieldCustom extends StatelessWidget {
//   final String title;
//   final String placeholder;
//   final double? width;
//   final IconData? icon;
//   final bool? isMultiLine;
//   final String? type;
//   final TextInputType? keyboardType;
//   final TextEditingController? controller;
//   final void Function(String)? onChanged;

//   const FormFieldCustom(
//       {super.key,
//       required this.placeholder,
//       required this.title,
//       this.icon,
//       this.width,
//       this.isMultiLine,
//       this.type = 'TEXT',
//       this.controller,
//       this.keyboardType,
//       this.onChanged});

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != DateTime.now()) {
//       // Handle the selected date value
//       DateTime localPicked = picked.toLocal(); // Convert to local time
//       String formattedDate = localPicked.toString().split(' ')[0]; // Get only the date part
//       controller?.text = formattedDate; // Update the text field with the formatted date
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width ?? double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (title != '') Text(title),
//           const SizedBox(
//             height: gap - 2,
//           ),
//           if (type == 'TEXT')
//             TextFormField(
//               validator: (String? arg) {
//                 if (arg!.length < 3) {
//                   return 'Text must be more than 2 characters';
//                 }
//                 return null;
//               },
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: placeholder,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: Colors.grey,
//                   ),
//                   borderRadius: BorderRadius.circular(5.5),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: primary, width: 2),
//                   borderRadius: BorderRadius.circular(5.5),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: padding),
//                 prefixIcon: icon != null ? Icon(icon) : null,
//               ),
//               maxLines: null,
//               minLines: isMultiLine ?? false ? 4 : 1,
//               onSaved: (String? val) {
//                 // Handle the saved value for text type.
//               },
//               onChanged: onChanged,
//               keyboardType: keyboardType ?? TextInputType.text,
//             )
//           else if (type == 'DATE')
//             TextFormField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: placeholder,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: Colors.grey,
//                   ),
//                   borderRadius: BorderRadius.circular(5.5),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: primary, width: 2),
//                   borderRadius: BorderRadius.circular(5.5),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 15.0,
//                   horizontal: padding,
//                 ),
//                 prefixIcon: icon != null ? Icon(icon) : null,
//               ),
//               maxLines: null,
//               minLines: isMultiLine ?? false ? 4 : 1,
//               onTap: () => _selectDate(context),
//               readOnly: true, // Prevent manual text input
//             ),
//         ],
//       ),
//     );
//   }
// }

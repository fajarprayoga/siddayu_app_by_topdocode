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

import '../../../data/service/local/auth.dart';
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
                    .onPressed(() async {
                      final user = await Auth.user();

                      if (context.mounted && user.id != null) {
                        context.push(Paths.formKegiatan, extra: {'kegiatan': data, 'user': user});
                      }
                    })
                    .lz
                    .hide(data == null)
              ],
            ),
            body: formActivityProvider.watch((state) {
              bool isOwner = notifier.user?.id == data?.createdBy;

              return LzFormList(
                style: const LzFormStyle(type: FormType.topAligned, inputBorderColor: Colors.black38),
                children: [
                  LzForm.input(
                      label: 'Nama Kegiatan', hint: 'Masukan nama kegiatan', model: forms['name'], disabled: !isOwner),
                  LzForm.input(
                      label: 'Tanggal Kegiatan',
                      hint: 'Masukan tanggal kegiatan',
                      suffixIcon: Ti.calendar,
                      model: forms['activity_date'],
                      disabled: !isOwner,
                      onTap: (control) {
                        if (isOwner) {
                          LzPicker.datePicker(context, initialDate: control.text.toDate()).then((value) {
                            control.text = value.format('dd-MM-yyyy');
                          });
                        }
                      }),
                  LzForm.input(
                    label: 'Deskripsi Kegiatan',
                    hint: 'Masukan deskripsi kegiatan',
                    maxLines: 5,
                    maxLength: 500,
                    model: forms['description'],
                    disabled: !isOwner,
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
                              Expanded(
                                  child: CustomTextfield(
                                hint: 'Sub kegiatan',
                                controller: item.name,
                                disabled: !isOwner,
                              )),
                              CustomTextfield(
                                hint: '0',
                                controller: item.total,
                                keyboard: Tit.number,
                                formatters: [InputFormat.currency('.')],
                                disabled: !isOwner,
                                onFocus: (value) {
                                  if (!value) {
                                    notifier.justUpdate();
                                  }
                                },
                              ).sized(width: 100).margin(l: 5),
                              if (isOwner)
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
                      }),
                      Row(
                        children: [
                          Text(
                            'Total: ${notifier.grandTotal().idr()}',
                            style: Gfont.bold,
                          ).margin(v: 10),
                        ],
                      ).end
                    ]).start;
                  }),

                  if (isOwner)
                    Textr(
                      'Tambah Sub Kegiatan',
                      icon: Ti.plus,
                      style: Gfont.bold,
                      padding: Ei.sym(v: 10),
                    ).onTap(() => notifier.addSubActivity())
                ],
              );
            }),
            bottomNavigationBar: formActivityProvider.watch(
              (state) {
                bool isSKD = notifier.user?.role?.code == 'SKD';

                if (!isSKD && notifier.user?.id != data?.createdBy) {
                  return const SizedBox();
                }

                return LzButton(
                  text: isSKD
                      ? 'Approve'
                      : data == null
                          ? 'Simpan'
                          : 'Perbarui',
                  color: primary,
                  textColor: Colors.white,
                  onTap: (_) async {
                    final res = await notifier.onSubmit(data?.id, isSKD);
                    if (res != null && context.mounted) {
                      context.pop(res?['data'] ?? {});
                    }
                  },
                ).theme1();
              },
            )),
      ),
    );
  }
}

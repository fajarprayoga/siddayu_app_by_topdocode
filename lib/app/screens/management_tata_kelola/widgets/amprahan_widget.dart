import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/core/helpers/utils.dart';
import 'package:todo_app/app/providers/kegiatan/form_kegiatan_provider.dart';

import '../../../data/models/amprahan.dart';
import '../../../widgets/custom_textfield.dart';
import '../views/form_kegiatan_screen.dart';

class ListAmprahanWidget extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<FormKegiatanNotifier, FormKegiatanState> provider;
  const ListAmprahanWidget(this.provider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return provider.watchX((value, notifier) => Column(
          children: value.amprahans.generate((item, i) =>
              SlideUp(delay: (i + 1) * 100, child: AmprahanWidget(notifier, item, i, provider).margin(b: 25))),
        ));
  }
}

class AmprahanWidget extends StatelessWidget {
  final FormKegiatanNotifier notifier;
  final Amprahan amprahan;
  final int index;
  final AutoDisposeStateNotifierProvider<FormKegiatanNotifier, FormKegiatanState> provider;
  const AmprahanWidget(this.notifier, this.amprahan, this.index, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: Maa.spaceBetween,
          children: [
            Text('Amprahan', style: Gfont.bold),
            const Icon(
              Icons.close,
              color: Colors.red,
            ).onTap(() => notifier.removeAmprahan(index))
          ],
        ),
        Container(
          padding: Ei.all(15),
          margin: Ei.only(t: 10),
          decoration:
              BoxDecoration(color: Colors.white, border: Br.all(color: Colors.black45), borderRadius: Br.radius(8)),
          child: Column(
            crossAxisAlignment: Caa.start,
            children: [
              CustomTextfield2(
                label: 'No Amprahan',
                hint: '2465768798900',
                keyboard: Tit.number,
                controller: amprahan.noAmprahan,
              ).margin(b: 15),

              // file section
              FKSection(
                  title: 'Dokumentasi Kegiatan',
                  textButton: 'Upload File Dokumentasi Kegiatan',
                  onTap: () async {
                    final files = await Helper.pickFiles();
                    notifier.addFileDokumentasiKegiatan(files, index);
                  }),

              // list of file dokumentasi kegiatan
              FkFileContent('doc_kegiatan', files: amprahan.fileDokumentasiKegiatan, onRemove: (i) {
                notifier.removeFileAmprahan('doc_kegiatan', i, index);
              }, provider: provider),

              CustomTextfield2(
                label: 'Total Realisasi Anggaran',
                hint: 'Masukkan total realisasi anggaran',
                keyboard: Tit.number,
                controller: amprahan.totalRealisasiAnggaran,
              ).margin(b: 15),

              CustomTextfield2(
                label: 'Sumber Dana',
                hint: 'Masukkan sumber dana',
                controller: amprahan.sumberDana,
              ).margin(b: 15),

              CustomTextfield2(
                label: 'Tanggal Amprahan',
                hint: 'Inputkan tanggal amprahan',
                suffixIcon: Ti.calendar,
                controller: amprahan.amprahanDate,
                onTap: () {
                  LzPicker.datePicker(context).then((value) {
                    amprahan.amprahanDate.text = value.format();
                  });
                },
              ).margin(b: 15),

              CustomTextfield2(
                label: 'Tanggal Pencaiaran',
                hint: 'Inputkan tanggal pencaiaran',
                suffixIcon: Ti.calendar,
                controller: amprahan.disbuermentDate,
                onTap: () {
                  LzPicker.datePicker(context).then((value) {
                    amprahan.disbuermentDate.text = value.format();
                  });
                },
              ).margin(b: 15),

              // pajak
              FKSection(
                  title: 'Pajak',
                  textButton: 'Upload File Dokumentasi Pajak',
                  onTap: () async {
                    final files = await Helper.pickFiles();
                    notifier.addFileDokumentasiPajak(files, index);
                  }),

              CustomCheckbox(
                  value: amprahan.isPajak,
                  onTap: () {
                    notifier.checkPajak(!amprahan.isPajak, index);
                  }),

              // list of file pajak
              FkFileContent('pajak', files: amprahan.fileDokumentasiPajak, onRemove: (i) {
                notifier.removeFileAmprahan('pajak', i, index);
              }, provider: provider),

              LzButton(
                  text: 'Simpan',
                  color: primary,
                  onTap: (_) {
                    notifier.onSubmitAmprahan(index);
                  }).sized(context.width)
            ],
          ),
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function()? onTap;
  const CustomCheckbox({super.key, this.value = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkTouch(
      onTap: onTap,
      border: Br.all(color: Colors.black38),
      radius: Br.radius(8),
      margin: Ei.only(b: 15),
      child: SizedBox(
        width: 25,
        height: 25,
        child: value ? const Icon(Ti.check) : const None(),
      ),
    );
  }
}

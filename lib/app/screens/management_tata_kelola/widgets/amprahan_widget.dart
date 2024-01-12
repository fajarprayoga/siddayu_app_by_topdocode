import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/extensions/list_extension.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/core/extensions/widget_extension.dart';
import 'package:todo_app/app/core/helpers/shortcut.dart';
import 'package:todo_app/app/core/helpers/utils.dart';
import 'package:todo_app/app/providers/kegiatan/form_kegiatan_provider.dart';
import 'package:todo_app/app/widgets/animations/slideup.dart';

import '../../../data/models/amprahan.dart';
import '../../../widgets/form_field_custom.dart';
import '../views/form_kegiatan_screen.dart';

class ListAmprahanWidget extends ConsumerWidget {
  const ListAmprahanWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return formKegiatanProvider.watchX((value, notifier) => Column(
          children: value.amprahans.generate((item, i) => SlideUp(
              delay: (i + 1) * 100,
              child: AmprahanWidget(notifier, item, i).margin(b: 25))),
        ));
  }
}

class AmprahanWidget extends StatelessWidget {
  final FormKegiatanNotifier notifier;
  final Amprahan amprahan;
  final int index;
  const AmprahanWidget(this.notifier, this.amprahan, this.index, {super.key});

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
          decoration: BoxDecoration(
              color: Colors.white,
              border: Br.all(color: Colors.black45),
              borderRadius: Br.radius(8)),
          child: Column(
            crossAxisAlignment: Caa.start,
            children: [
              FormFieldCustom(
                title: 'No Amprahan',
                placeholder: '2465768798900',
                titleStyle: Gfont.bold,
                keyboardType: Tit.number,
                controller: amprahan.noAmprahan,
              ).margin(b: 15),

              // file section
              FKSection(
                  title: 'Dokumentasi Kegiatan',
                  textButton: 'Upload File Dokumentasi Kegiatan',
                  onTap: () async {
                    final files = await Utils.pickFiles();
                    notifier.addFileDokumentasiKegiatan(files, index);
                  }),

              // list of file dokumentasi kegiatan
              FkFileContent('doc_kegiatan',
                  files: amprahan.fileDokumentasiKegiatan, onRemove: (i) {
                notifier.removeFileAmprahan('doc_kegiatan', i, index);
              }),

              FormFieldCustom(
                title: 'Total Realisasi Anggaran',
                placeholder: 'Masukkan total realisasi anggaran',
                titleStyle: Gfont.bold,
                keyboardType: Tit.number,
                controller: amprahan.totalRealisasiAnggaran,
              ).margin(b: 15),
              FormFieldCustom(
                title: 'Sumber Dana',
                placeholder: 'Masukkan sumber dana',
                titleStyle: Gfont.bold,
                keyboardType: Tit.number,
                controller: amprahan.sumberDana,
              ).margin(b: 15),

              // pajak
              FKSection(
                  title: 'Pajak',
                  textButton: 'Upload File Dokumentasi Pajak',
                  onTap: () async {
                    final files = await Utils.pickFiles();
                    notifier.addFileDokumentasiPajak(files, index);
                  }),

              // list of file pajak
              FkFileContent('pajak', files: amprahan.fileDokumentasiPajak,
                  onRemove: (i) {
                notifier.removeFileAmprahan('pajak', i, index);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

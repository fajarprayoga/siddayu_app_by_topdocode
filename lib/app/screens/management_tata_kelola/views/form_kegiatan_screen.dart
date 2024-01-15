import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/core/helpers/utils.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';

import '../../../providers/kegiatan/form_kegiatan_provider.dart';
import '../../../widgets/primary_button.dart';
import '../widgets/amprahan_widget.dart';

class FormKegiatanScreen extends ConsumerWidget {
  final Kegiatan kegiatan;
  const FormKegiatanScreen({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(formKegiatanProvider.notifier);

    return Wrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Management Tata Kelola'),
        ),
        body: ListView(
          padding: Ei.all(20),
          physics: BounceScroll(),
          children: [
            Column(
              crossAxisAlignment: Caa.start,
              children: [
                FKSection(
                    title: 'SK',
                    textButton: 'Upload File SK',
                    onTap: () async {
                      final files = await Helper.pickFiles();
                      notifier.addFileSK(files);
                    }),

                // list of file sk
                formKegiatanProvider.watch((value) => FkFileContent('sk', files: value.fileSK)),

                // section berita acara
                FKSection(
                    title: 'Berita Acara',
                    textButton: 'Upload File Berita Acara',
                    onTap: () async {
                      final files = await Helper.pickFiles();
                      notifier.addFileBeritaAcara(files);
                    }),

                // list of file berita acara
                formKegiatanProvider.watch((value) => FkFileContent('berita_acara', files: value.fileBeritaAcara)),

                // section option
                FKSection(
                    title: 'Option (PBJ)',
                    textButton: 'Upload File Option',
                    onTap: () async {
                      final files = await Helper.pickFiles();
                      notifier.addFileOption(files);
                    }),

                // list of file option
                formKegiatanProvider.watch((value) => FkFileContent('option', files: value.fileOption)),

                // amprahan widget
                const ListAmprahanWidget(),

                // button tambah no amprahan
                Textr('Tambah No Amprahan', icon: Icons.add, style: Gfont.bold).onTap(() {
                  notifier.addAmprahan();
                }),

                // button submit
                // PrimaryButton('Simpan / Approve', onTap: () => notifier.onSubmit()).margin(t: 35),
              ],
            )
          ],
        ),
        bottomNavigationBar: LzButton(
            text: 'Simpan / Approve',
            color: primary,
            textColor: Colors.white,
            onTap: (_) {
              notifier.onSubmit(kegiatan);
            }).theme1(),
      ),
    );
  }
}

class FKSection extends StatelessWidget {
  final String title, textButton;
  final Function()? onTap;
  const FKSection({super.key, required this.title, required this.textButton, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Ei.only(b: 20),
      child: Column(
        crossAxisAlignment: Caa.start,
        children: [
          Textr(
            title,
            style: Gfont.bold,
            margin: Ei.only(b: 5),
          ),
          PrimaryButton(textButton, icon: Icons.upload, onTap: onTap),
          Textr(
            'Silakan upload dengan format PDF',
            style: Gfont.fs14.muted,
            margin: Ei.only(t: 10),
          ),
        ],
      ),
    );
  }
}

class FkFileContent extends ConsumerWidget {
  final String label;
  final List<File> files;
  final Function(int index)? onRemove;
  const FkFileContent(this.label, {super.key, this.files = const [], this.onRemove});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(formKegiatanProvider.notifier);

    if (files.isEmpty) {
      return Container(
        margin: Ei.only(b: 35),
        decoration: BoxDecoration(border: Br.all(color: Colors.black38), borderRadius: Br.radius(8)),
        padding: Ei.sym(v: 7, h: 10),
        width: context.width,
        child: Text('Tidak ada file', style: Gfont.muted),
      );
    }

    return Container(
      margin: Ei.only(b: 35),
      decoration: BoxDecoration(border: Br.all(color: Colors.black54), borderRadius: Br.radius(8)),
      child: Column(
        children: files.generate((file, i) {
          String name = file.path.split('/').last;

          return SlideUp(
            delay: (i + 1) * 100,
            child: Container(
              padding: Ei.sym(v: 7, h: 10),
              decoration: BoxDecoration(
                border: Br.only(['t'], except: i == 0),
              ),
              child: Row(
                mainAxisAlignment: Maa.spaceBetween,
                children: [
                  Text(name),
                  const Icon(
                    Icons.close,
                    color: Colors.red,
                  ).onTap(() => onRemove != null ? onRemove!.call(i) : notifier.removeFile(label, i))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

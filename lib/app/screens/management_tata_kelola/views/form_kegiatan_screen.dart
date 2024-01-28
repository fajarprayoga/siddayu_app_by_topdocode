import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/core/helpers/utils.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/widgets/custom_appbar.dart';

import '../../../data/models/user/user.dart';
import '../../../providers/kegiatan/form_kegiatan_provider.dart';
import '../../../widgets/primary_button.dart';
import '../widgets/amprahan_widget.dart';

class FormKegiatanScreen extends ConsumerWidget {
  final Kegiatan kegiatan;
  final User user;
  const FormKegiatanScreen({super.key, required this.kegiatan, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = formKegiatanProvider(kegiatan);
    final notifier = ref.read(provider.notifier);

    final userRole = user.role;
    // [SK, Berita Acara, Option PBJ] : hanya bisa diisi role ST
    // Amprahan : [Pajak, upload file documentasi Pajak, Bukti Pajak] hanya bisa diisi oleh role SKU

    final roleName = userRole?.code;
    bool isST = roleName == 'ST';

    return Wrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomAppbar(
            title: 'Management Tata Kelola',
            subtitle: 'Kegiatan / Detail / Kegiatan 1',
          ),
        ),
        body: LzListView(
          onRefresh: () async {
            notifier.getData();
          },
          children: [
            Opacity(
              opacity: isST ? 1 : 0.5,
              child: Column(
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
                  provider.watch((value) => FkFileContent('sk', files: value.fileSK, provider: provider)),

                  // section berita acara
                  FKSection(
                      title: 'Berita Acara',
                      textButton: 'Upload File Berita Acara',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileBeritaAcara(files);
                      }),

                  // list of file berita acara
                  provider.watch(
                      (value) => FkFileContent('operational_report', files: value.fileBeritaAcara, provider: provider)),

                  // section option
                  FKSection(
                      title: 'Option (PBJ)',
                      textButton: 'Upload File Option',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileOption(files);
                      }),

                  // list of file option
                  provider.watch((value) => FkFileContent('other', files: value.fileOption, provider: provider)),

                  // button submit
                  // PrimaryButton('Simpan / Approve', onTap: () => notifier.onSubmit()).margin(t: 35),
                ],
              ),
            ).lz.ignore(!isST),

            // amprahan widget
            ListAmprahanWidget(provider),

            // button tambah no amprahan
            Textr('Tambah No Amprahan', icon: Icons.add, style: Gfont.bold).onTap(() {
              notifier.addAmprahan();
            }),
          ],
        ),
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
  final AutoDisposeStateNotifierProvider<FormKegiatanNotifier, FormKegiatanState> provider;
  const FkFileContent(this.label, {super.key, this.files = const [], this.onRemove, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(provider.notifier);

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
                  Flexible(
                    child: InkWell(
                      onTap: () => _showFullModal(context, file.toString()),
                      child: Text(
                        name,
                        overflow: Tof.ellipsis,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.close,
                    color: Colors.red,
                  ).onTap(() {
                    LzConfirm(
                      title: 'Hapus File',
                      message: 'Apakah Anda yakin ingin menghapus file ini?',
                      onConfirm: () {
                        onRemove != null ? onRemove!.call(i) : notifier.removeFile(label, i);
                      },
                    ).show(context);
                  })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

_showFullModal(context, String path) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false, // should dialog be dismissed when tapped outside
    barrierLabel: "Modal", // label for barrier
    transitionDuration: const Duration(milliseconds: 500), // how long it takes to popup dialog after button click
    pageBuilder: (_, __, ___) {
      // your widget implementation
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: const Text(
              "Document Pdf",
              style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
            ),
            elevation: 0.0),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xfff8f8f8),
                width: 1,
              ),
            ),
          ),
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plugin ped Viewer
                // PDFView(
                //   filePath: path,
                //   enableSwipe: true,
                //   swipeHorizontal: true,
                //   autoSpacing: false,
                //   pageFling: false,
                //   onError: (error) {
                //     print(error.toString());
                //   },
                //   onPageError: (page, error) {
                //     print('$page: ${error.toString()}');
                //   },
                // ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

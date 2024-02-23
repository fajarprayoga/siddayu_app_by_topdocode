import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
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
    bool isOwner = user.id == kegiatan.createdBy;

    return Wrapper(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppbar(
            title: 'Management Tata Kelola',
            subtitle: 'Detail / ${kegiatan.name}',
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
                      title: 'Surat Keputusan Prebekel',
                      textButton: 'Upload File SK',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileSK(files);
                      }),
                  provider.watch(
                      (value) => FkFileContent('sk', files: value.fileSK, provider: provider, removable: isOwner)),
                  // list of file sk

                  provider.watch((value) => FkFileContent('sk', files: value.fileSK, provider: provider)),
                  FKSection(
                      title: 'File Pendukung',
                      textButton: 'Upload File Pendukung',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileSupport(files);
                      }),

                  // list of file sk
                  provider.watch((value) => FkFileContent('support', files: value.fileSupport, provider: provider)),

                  // other
                  FKSection(
                      title: 'Berita Acara',
                      textButton: 'Upload File Berita Acara',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileBeritaAcara(files);
                      }),

                  // Surat perjanjian
                  provider.watch(
                      (value) => FkFileContent('operational_report', files: value.fileBeritaAcara, provider: provider)),
                  // section berita acar

                  // Surat Pewrjanjian kerjasama
                  FKSection(
                      title: 'Surat Perjanjian Kerjasama',
                      textButton: 'Upload File Surat Perjanjian',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileSuratPerjanjian(files);
                      }),

                  // list of file berita acara
                  provider.watch((value) => FkFileContent(
                        'letter_of_agreement',
                        files: value.fileSuratPerjanjian,
                        provider: provider,
                        removable: isOwner,
                      )),

                  // other
                  FKSection(
                      title: 'Berita Acara',
                      textButton: 'Upload File Berita Acara',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileBeritaAcara(files);
                      }),

                  // Surat perjanjian
                  provider.watch((value) => FkFileContent('operational_report',
                      files: value.fileBeritaAcara, provider: provider, removable: isOwner)),
                  // section berita acara
                  FKSection(
                      title: 'Surat Perjanjian Kerjasama',
                      textButton: 'Upload File Kerjasama',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileSuratPerjanjian(files);
                      }),

                  // list of file berita acara
                  provider.watch((value) => FkFileContent('letter_of_agreement',
                      files: value.fileSuratPerjanjian, provider: provider, removable: isOwner)),

                  // section option
                  FKSection(
                      title: 'Pengadaan Barang dan Jasa',
                      textButton: 'Upload File Option',
                      onTap: () async {
                        final files = await Helper.pickFiles();
                        notifier.addFileOption(files);
                      }),

                  // list of file option
                  provider.watch((value) =>
                      FkFileContent('other', files: value.fileOption, provider: provider, removable: isOwner)),

                  // button submit
                  // PrimaryButton('Simpan / Approve', onTap: () => notifier.onSubmit()).margin(t: 35),
                ],
              ),
            ).lz.ignore(!isST),

            // amprahan widget
            ListAmprahanWidget(provider, kegiatan),

            // button tambah no amprahan

            if (isOwner)
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
  final List<String> filesName;
  final Function(int index)? onRemove;
  final AutoDisposeStateNotifierProvider<FormKegiatanNotifier, FormKegiatanState> provider;
  final bool removable;
  const FkFileContent(this.label,
      {super.key,
      this.files = const [],
      this.filesName = const [],
      this.onRemove,
      required this.provider,
      this.removable = true});

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
          final files = notifier.tempFiles[label] ?? [];
          String name = files.isEmpty ? '-' : files[i]['title'] ?? file.path.split('/').last;

          if (files.isEmpty) {
            name = file.path.split('/').last;

            if (filesName.isNotEmpty) {
              name = filesName[i];
            }
          }

          return SlideUp(
            delay: (i + 1) * 100,
            child: InkTouch(
              onTap: () {
                context.bottomSheet(FileViewer(file));
              },
              radius: Br.radius(5),
              child: Container(
                padding: Ei.sym(v: 7, h: 10),
                decoration: BoxDecoration(
                  border: Br.only(['t'], except: i == 0),
                ),
                child: Row(
                  mainAxisAlignment: Maa.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: Tof.ellipsis,
                      ),
                    ),
                    if (removable)
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
            ),
          );
        }),
      ),
    );
  }
}

class FileViewer extends StatelessWidget {
  final File file;
  const FileViewer(this.file, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isUrl = false, isPdfUrl = false;
    bool isImg = false, isImageUrl = false;

    isUrl = file.path.startsWith('http');
    isImg = file.path.endsWith('.png') || file.path.endsWith('.jpg') || file.path.endsWith('.jpeg');

    isPdfUrl = isUrl && file.path.endsWith('.pdf');
    isImageUrl = isUrl && isImg;

    return Scaffold(
        appBar: AppBar(title: const Text('File Viewer')),
        body: Center(
            child: isPdfUrl
                ? SfPdfViewer.network(file.path)
                : isImageUrl
                    ? LzImage(file.path)
                    : isImg && !isImageUrl
                        ? Image.file(file)
                        : SfPdfViewer.file(file)));
  }
}

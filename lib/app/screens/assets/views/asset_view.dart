import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/widgets/custom_appbar.dart';

import '../../../data/models/document.dart';
import '../providers/asset_provider.dart';

class AssetView extends ConsumerWidget {
  final Kegiatan kegiatan;
  const AssetView({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = assetProvider(kegiatan.id!);
    final notifier = ref.read(provider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const CustomAppbar(
            title: 'Management Tata Kelola',
            subtitle: 'Dokumen',
          ),
        ),
        body: provider.watch((state) => state.documents.when(
            data: (docs) {
              if (docs.isEmpty) {
                return LzNoData(
                  message: 'Tidak ada dokumen',
                  onTap: () => notifier.getData(),
                );
              }

              return LzListView(children: [
                ...notifier.documents.generate((item, i) {
                  String type = item['type'];
                  List<Document> documents = item[type] ?? [];

                  return Column(children: [
                    Text(type.ucwords, style: Gfont.bold).margin(b: 10),
                    Wrap(children: [
                      ...documents.generate((doc, i) {
                        String url = doc.url ?? '';
                        String title = doc.title ?? '';

                        bool isPdf = url.isNotEmpty && url.contains('.pdf');

                        return SizedBox(
                          width: context.width / 3,
                          child: InkTouch(
                            onTap: () {},
                            border: Br.all(),
                            radius: Br.radius(5),
                            padding: Ei.sym(h: 15, v: 25),
                            color: Colors.white,
                            child: Column(
                              children: [
                                LzImage(
                                  isPdf ? 'pdf.png' : url,
                                  width: 50,
                                  height: 60,
                                ).margin(b: 10),
                                Text(
                                  title,
                                  style: Gfont.fs14,
                                  overflow: Tof.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ])
                  ]).start;
                })
              ]);
            },
            error: (e, s) => LzNoData(
                  message: '$e, $s',
                ),
            loading: () => LzLoader.bar())));
  }
}

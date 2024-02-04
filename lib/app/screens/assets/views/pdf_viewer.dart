import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';

import '../providers/asset_provider.dart';

class PdfViewer extends ConsumerWidget {
  final int index;
  final String activityID;
  const PdfViewer(this.activityID, {super.key, this.index = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = assetProvider(activityID);
    final notifier = ref.read(provider.notifier);

    Bindings.onRendered(() {
      notifier.selectPDF(index);
    });

    return Scaffold(
        appBar: AppBar(
            title: provider.watch((state) {
              final docs = state.documents.value ?? [];
              String title = '';

              if (docs.length >= notifier.index) {
                title = docs[notifier.index].title ?? '';
              }

              return Text(title);
            }),
            actions: [
              ...[Ti.arrowLeft, Ti.arrowRight].generate((icon, i) {
                return Icon(icon).onPressed(() {
                  if (i == 0 && notifier.index == 0) return;
                  if (i == 1 && notifier.index == notifier.length - 1) return;

                  notifier.selectPDF(i == 0 ? notifier.index - 1 : notifier.index + 1);
                });
              })
            ]),
        body: provider.watch((state) {
          String url = notifier.pdfs[notifier.index];
          bool isLoading = notifier.isLoading;

          if (isLoading) {
            return LzLoader.bar();
          }

          return SfPdfViewer.network(url);
        }));
  }
}

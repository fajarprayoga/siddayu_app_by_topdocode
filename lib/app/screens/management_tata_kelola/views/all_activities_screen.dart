import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/core/extensions/riverpod_extension.dart';
import 'package:todo_app/app/data/models/kegiatan/kegiatan.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/widgets/custom_appbar.dart';

import '../../../providers/kegiatan/activity_provider.dart';

class AllActivitiesScreen extends ConsumerWidget {
  const AllActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(allActivityProvider.notifier);

    Future<void> selectDateRange(BuildContext context) async {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023),
        lastDate: DateTime.now(),
        initialDateRange: notifier.dateRange,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        saveText: 'Pilih',
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primary,
              colorScheme: const ColorScheme.light(primary: primary),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white, textStyle: Gfont.bold.copyWith(letterSpacing: 2))),
            ),
            child: child ?? const SizedBox(),
          );
        },
      );

      if (picked != null) {
        notifier.setDate(picked);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppbar(
          title: 'Management Tata Kelola',
          subtitle: 'All Kegiatan',
        ),
      ),
      body: LzListView(
        onRefresh: () async {
          notifier.doSearch();
        },
        onScroll: (scroller) {
          if ((scroller.position.pixels + 100) >= scroller.position.maxScrollExtent) {
            notifier.onGetMore();
          }
        },
        children: [
          Row(
            children: [
              Expanded(
                child: LzTextField(
                  hint: 'Ketik nama kegiatan',
                  prefixIcon: const Icon(Ti.search),
                  controller: notifier.keyword,
                ).bordered(),
              ),
              InkTouch(
                onTap: () {
                  selectDateRange(context);
                },
                padding: Ei.sym(v: 14, h: 20),
                color: Colors.white,
                radius: Br.radius(5),
                border: Br.all(),
                margin: Ei.only(l: 10),
                child: const Icon(Ti.calendarEvent),
              )
            ],
          ),
          Container(
            padding: Ei.sym(v: 10),
            margin: Ei.only(b: 25),
            child: allActivityProvider.watch((state) {
              return Textr(
                state.date == null ? 'Silakan pilih tanggal kegiatan.' : notifier.getDate,
                style: Gfont.muted,
                icon: Ti.calendarEvent,
              );
            }),
          ),
          allActivityProvider.watch((state) {
            return Column(
              children: state.activities.generate((item, i) {
                final ikey = GlobalKey();

                return InkTouch(
                  onTap: () {
                    DropX.show(ikey, options: ['Edit', 'Detail', 'Hapus'].options(dangers: [2]), onSelect: (value) {
                      if (value.index == 0) {
                        context.push(Paths.formManagementTataKelola, extra: item).then((value) {
                          if (value != null) {
                            value as Map<String, dynamic>;
                            notifier.updateData(Kegiatan.fromJson(value));
                          }
                        });
                      } else if (value.index == 1) {
                        logg('halo');
                      } else if (value.index == 2) {
                        LzConfirm(
                          title: 'Hapus Data',
                          message: 'Apakah anda yakin ingin menghapus data kegiatan ini?',
                          onConfirm: () {
                            notifier.deleteData(item.id!);
                          },
                        ).show(context);
                      }
                    });
                  },
                  padding: Ei.all(20),
                  border: Br.only(['t'], except: i == 0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(item.name ?? ''),
                        ],
                      ).start,
                      Icon(
                        Ti.chevronRight,
                        color: Colors.black45,
                        key: ikey,
                      )
                    ],
                  ).between,
                );
              }),
            );
          }),

          // pagination loading
          allActivityProvider.watch((state) {
            return state.isPaginating ? LzLoader.bar() : const SizedBox();
          })
        ],
      ),
      bottomNavigationBar: LzButton(
        text: 'Cari Kegiatan',
        color: primary,
        onTap: (_) => notifier.doSearch(),
      ).theme1(),
    );
  }
}

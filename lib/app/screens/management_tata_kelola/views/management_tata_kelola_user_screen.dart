import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/data/models/auth.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/data/service/local/storage.dart';
import 'package:todo_app/app/providers/activity/activity_user_provider.dart';
import 'package:todo_app/app/routes/paths.dart';

import '../../../core/helpers/logg.dart';

class ManagementTataKelolaDetail extends ConsumerWidget {
  final params;
  const ManagementTataKelolaDetail({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? authLocal = prefs.getString('auth');
    final auth = Auth.fromJson(json.decode(authLocal ?? ''));
    final refKegiatanProvider = ref.watch(activityUserProvider(params['id']));
    final notifier = ref.read(activityUserProvider(params['id']).notifier);

    return Scaffold(
      appBar: AppBar(
          title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Management Tata Kelola ",
            style: Gfont.bold,
          ),
          Text(
            "Kegiatan",
            style: Gfont.fs14,
          )
        ],
      )),
      body: RefreshIndicator(
        onRefresh: () async {
          notifier.getKegiatan();
        },
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              const SizedBox(height: gap),
              if (auth.id == params['id'])
                ButtonAddKegiatan(
                  notifier: notifier,
                  onTap: () {
                    context.push(Paths.formManagementTataKelola).then((value) {
                      value as Map<String, dynamic>;
                      notifier.addData(Kegiatan.fromJson(value));
                    });
                  },
                ),
              const SizedBox(
                height: gap,
              ),
              Expanded(
                  child: refKegiatanProvider.when(
                      data: (data) {
                        logg(data);

                        if (data.isEmpty) {
                          return const Center(child: Text('data is empty'));
                        }
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListKegiatan(item: data[index], notifier: notifier);
                          },
                        );
                      },
                      error: (e, s) => Center(child: Text('errorr $e')),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}

class ListKegiatan extends StatelessWidget {
  final Kegiatan item;
  final ActivityUserNotifier notifier;
  const ListKegiatan({Key? key, required this.item, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: marginVertical),
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          context.push(Paths.formManagementTataKelolaDetail, extra: item).then((value) {
            value as Map<String, dynamic>;
            notifier.updateData(Kegiatan.fromJson(value));
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(
                    width: gap,
                  ),
                  Flexible(
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right,
              color: primary,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}

class ButtonAddKegiatan extends StatelessWidget {
  final ActivityUserNotifier notifier;
  final Function()? onTap;

  const ButtonAddKegiatan({super.key, required this.notifier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius - 10),
            color: primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                "Tambah Kegiatan",
                style: Gfont.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

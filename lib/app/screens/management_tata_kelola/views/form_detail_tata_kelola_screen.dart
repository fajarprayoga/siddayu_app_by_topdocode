import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/providers/activity/activity_detail_provider.dart';
import 'package:todo_app/app/routes/paths.dart';

class FormDetailTataKelola extends ConsumerStatefulWidget {
  final Kegiatan kegiatan;
  const FormDetailTataKelola({
    Key? key,
    required this.kegiatan,
  }) : super(key: key);

  @override
  ConsumerState<FormDetailTataKelola> createState() => _FormDetailTataKelolaState();
}

class _FormDetailTataKelolaState extends ConsumerState<FormDetailTataKelola> {
  List<Widget> formAmprahan = [];
  List<Widget> formSubKegiatan = [];

  @override
  Widget build(BuildContext context) {
    final activityProvider = ref.watch(activityDetailProvider(widget.kegiatan.id));
    final notifier = ref.read(activityDetailProvider(widget.kegiatan.id).notifier);

    return SafeArea(
      child: Scaffold(
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
                "Kegiatan / Detail ",
                style: Gfont.fs14,
              )
            ],
          ),
        ),
        body: activityProvider.when(
            data: (data) {
              return SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: padding),
                child: Container(
                  margin: const EdgeInsets.only(top: gap + 20),
                  padding: const EdgeInsets.symmetric(horizontal: padding + 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            // _showFullModal(context);
                            // context.push(Paths.formPertanggungJawaban);
                            // context.push(Paths.formPertanggungJawaban, extra: widget.kegiatan);

                            context.push(Paths.formKegiatan, extra: widget.kegiatan);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius - 10),
                              color: primary,
                            ),
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              'Pertanggung Jawaban',
                              style: Gfont.fs14.white,
                            ),
                          ),
                        ),
                      ),
                      FormFieldCustom(
                        title: 'Nama Kegiatan',
                        placeholder: 'Masukan nama kegiatan',
                        controller: notifier.name,
                      ),
                      FormFieldCustom(
                          title: 'Tanggal Kegiatan',
                          placeholder: 'Masukan tanggal kegiatan',
                          icon: Icons.date_range,
                          controller: notifier.activityDate,
                          type: 'DATE'),
                      FormFieldCustom(
                        title: 'Deskripsi Kegiatan',
                        placeholder: 'Masukan deskripsi kegiatan',
                        isMultiLine: true,
                        controller: notifier.description,
                      ),

                      Column(
                        children: List.generate(notifier.subActivities.length, (i) {
                          return subKegiatan(notifier.subActivities[i]);
                        }),
                      ),

                      // if (data.subActivities.length > 0)
                      //   ListView.builder(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: data.subActivities.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (context, index) {
                      //       // return Text('jalo');
                      //       return subKegiatan(index, data.subActivities);
                      //     },
                      //   ),
                      // if (formSubKegiatan.length > 0)
                      //   ListView.builder(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: formSubKegiatan.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (context, index) {
                      //       return formSubKegiatan[index];
                      //     },
                      //   ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // setState(() {
                          //   // formSubKegiatan.add(subKegiatan(null));
                          //   formSubKegiatan.add(subKegiatan((formSubKegiatan.length), formSubKegiatan));

                          //   // print(formSubKegiatan.length);
                          // });

                          notifier.addSubActivity();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Sub Kegiatan'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      ),
                      const SizedBox(
                        height: gap + 10,
                      ),
                      InkWell(
                        onTap: () async {
                          // await notifier.(widget.kegiatan.id);
                          final result = await notifier.updateActivity(widget.kegiatan.id);

                          if (result != null && context.mounted) {
                            context.pop(result);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius - 10),
                            color: primary,
                          ),
                          padding: const EdgeInsets.all(padding),
                          child: Text(
                            'Simpan',
                            style: Gfont.fs14.white,
                          ),
                        ),
                      )
                      // Checkbox(value: true, onChanged: (){})
                    ],
                  ),
                ),
              ));
            },
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }

  Row subKegiatan(SubActivity2 subActivity) {
    final name = subActivity.nameController;
    final total = subActivity.totalController;

    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FormFieldCustom(
            title: '',
            placeholder: 'Sub Kegiatan',
            controller: name,
            onChanged: (value) {
              subActivity.nameController.text = value;

              // if (index < subActivities.length) {
              //   subActivities[index] = {...subActivities[index], "name": value};
              // } else {
              //   subActivities.add({"name": value});
              // }
            },
          ),
        ),
        const SizedBox(
          width: gap,
        ),
        Row(
          children: [
            FormFieldCustom(
              width: 100,
              title: '',
              placeholder: '0',
              keyboardType: TextInputType.number,
              controller: total,
              onChanged: (value) {
                subActivity.totalController.text = value;
                // print(index);
                // if (index < subActivities.length) {
                //   subActivities[index] = {...subActivities[index], "total_budget": value};
                // } else {
                //   subActivities.add({"total_budget": value});
                // }
              },
            ),
            InkWell(
                onTap: () {
                  // setState(() {
                  //   formSubKegiatan.removeAt(index);
                  // });
                },
                child: Icon(
                  Icons.delete,
                  size: 32,
                  color: Colors.red[800],
                ))
          ],
        ),
      ],
    );
  }
}

enum Type { date, text }

class FormFieldCustom extends StatelessWidget {
  final String title;
  final String placeholder;
  final double? width;
  final IconData? icon;
  final bool? isMultiLine;
  final String? type;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final dynamic initialValue;
  final void Function(String)? onChanged;

  const FormFieldCustom(
      {super.key,
      required this.placeholder,
      required this.title,
      this.icon,
      this.width,
      this.isMultiLine,
      this.type = 'TEXT',
      this.controller,
      this.keyboardType,
      this.onChanged,
      this.initialValue});

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      // Handle the selected date value
      DateTime localPicked = picked.toLocal(); // Convert to local time
      String formattedDate = localPicked.toString().split(' ')[0]; // Get only the date part
      controller?.text = formattedDate; // Update the text field with the formatted date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != '') Text(title),
          const SizedBox(
            height: gap - 2,
          ),
          if (type == 'TEXT')
            TextFormField(
              validator: (String? arg) {
                if (arg!.length < 3) {
                  return 'Text must be more than 2 characters';
                }
                return null;
              },
              controller: controller,
              initialValue: initialValue,
              decoration: InputDecoration(
                hintText: placeholder,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: padding),
                prefixIcon: icon != null ? Icon(icon) : null,
              ),
              maxLines: null,
              minLines: isMultiLine ?? false ? 4 : 1,
              onSaved: (String? val) {
                // Handle the saved value for text type.
              },
              onChanged: onChanged,
              keyboardType: keyboardType ?? TextInputType.text,
            )
          else if (type == 'DATE')
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: padding,
                ),
                prefixIcon: icon != null ? Icon(icon) : null,
              ),
              maxLines: null,
              minLines: isMultiLine ?? false ? 4 : 1,
              onTap: () => _selectDate(context),
              readOnly: true, // Prevent manual text input
            ),
        ],
      ),
    );
  }
}

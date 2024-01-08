import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/data/models/kegiatan.dart';
import 'package:todo_app/app/providers/activity/activity_tanggung_jawab.dart';
import 'package:todo_app/app/widgets/form_field_custom.dart';
import 'package:todo_app/app/widgets/widget.dart';

class FormPertanggungJawaban extends ConsumerStatefulWidget {
  final Kegiatan kegiatan;
  const FormPertanggungJawaban({
    Key? key,
    required this.kegiatan,
  }) : super(key: key);

  @override
  ConsumerState<FormPertanggungJawaban> createState() =>
      _FormPertanggungJawabanState();
}

class _FormPertanggungJawabanState
    extends ConsumerState<FormPertanggungJawaban> {
  List<Widget> formAmprahan = [];
  List fileList = [];

  // amprahan
  List fieldAmprahan = [];

// type sk, operational_report,other
  void uploadFile(String type, notifier, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc'],
        type: FileType.custom);
    if (result != null) {
      // File file = File(result.files.single.path!);
      // print(file);
      setState(() {
        fileList.addAll(result.files.map((file) {
          return {'name': file.name, 'path': File(file.path!)};
        }));
        notifier.uploadDoc(context, fileList, type);
      });
      fileList = [];
    } else {
      print('cancel');
      // User canceled the picker
    }
  }

  void removeFile(List fileList, int index) {
    setState(() {
      fileList.removeAt(index);
    });
  }

  void removeAmprahan(List fileList, int index) {
    setState(() {
      formAmprahan.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier =
        ref.read(activitTanggungJawabProvider(widget.kegiatan.id).notifier);

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
              "Kegiatan / Detail / Amprahan",
              style: Gfont.fs14,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: gap + 20),
          padding: EdgeInsets.symmetric(horizontal: padding + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonIcon(
                  label: 'SK',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file SK',
                  onTapFunction: () {
                    uploadFile('sk', notifier, context);
                  }),
              if (notifier.fileListPro["sk"] != null &&
                  notifier.fileListPro["sk"]!.length > 0)
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notifier.fileListPro["sk"]?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String fileName = notifier.fileListPro["sk"]![index]
                              ["name"] ??
                          'Nama file tidak diketahui';
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_sharp,
                              size: 36,
                            ),
                            InkWell(
                              onTap: () => _showFullModal(context),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: gap,
                                  ),
                                  Text(
                                    fileName,
                                    // notifier.fileListPro[index]['sk']['name'],
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: gap,
                            ),
                            InkWell(
                              // onTap: () =>
                              //     removeFile(notifier.fileListPro, index),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ButtonIcon(
                  label: 'Berita Acara',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file Berita Acara',
                  onTapFunction: () {
                    uploadFile('operational_report', notifier, context);
                  }),
              ButtonIcon(
                  label: 'Optional (PBJ)',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file PBJ',
                  onTapFunction: () {}),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: formAmprahan.length,
                itemBuilder: (context, index) {
                  return amprahanWidget(
                      indexAmprahan: index,
                      fieldAmprahan: fieldAmprahan,
                      remove: () {
                        uploadFile('other', notifier, context);
                      });
                },
              ),
              const SizedBox(
                height: gap,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    formAmprahan.add(amprahanWidget(
                        indexAmprahan: formAmprahan.length,
                        fieldAmprahan: fieldAmprahan,
                        remove: () {}));
                  });
                },
                icon: const Icon(Icons.add),
                label: Text('Tambah Amprahan'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, onPrimary: Colors.black),
              ),
              SizedBox(
                height: gap + 10,
              ),
              InkWell(
                onTap: () {
                  // print(fieldAmprahan);
                  notifier.updateAmprahan(widget.kegiatan.id, fieldAmprahan);
                  // _showFullModal(context);
                  // print(notifier.fileListPro);
                  // notifier.uploadDoc(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius - 10),
                    color: primary,
                  ),
                  padding: EdgeInsets.all(padding),
                  child: Text(
                    'Simpan',
                    style: Gfont.fs14.white,
                  ),
                ),
              ),
              SizedBox(
                height: gap,
              )
              // Checkbox(value: true, onChanged: (){})
            ],
          ),
        ),
      ),
    );
  }

  _showFullModal(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible:
          false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(
          milliseconds:
              500), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                "Document Pdf",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Overpass',
                    fontSize: 20),
              ),
              elevation: 0.0),
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xfff8f8f8),
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black,
                            wordSpacing: 1)),
                  ),
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

  Container amprahanWidget(
      {int? indexAmprahan,
      required List fieldAmprahan,
      void Function()? remove}) {
    // Define your necessary variables and controllers here
    final TextEditingController noAmprahan = TextEditingController();
    final List<Map<String, dynamic>> documents = [];
    final TextEditingController totalRealisasi = TextEditingController();
    final TextEditingController sumberDana = TextEditingController();
    bool pajak = false;

    // Use the provided fileList
    void uploadFile(String type) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          allowedExtensions: ['pdf', 'doc'],
          type: FileType.custom);
      if (result != null) {
        // File file = File(result.files.single.path!);
        // print(file);
        setState(() {
          fileList.addAll(result.files.map((file) {
            return {'name': file.name, 'path': File(file.path!)};
          }));
        });

        if (indexAmprahan! < fieldAmprahan.length) {
          // Check if the 'documents' key exists
          if (fieldAmprahan[indexAmprahan].containsKey('documents')) {
            // Append to the existing 'documents' list
            fieldAmprahan[indexAmprahan]['documents'] = [
              ...fieldAmprahan[indexAmprahan]['documents'],
              ...fileList
            ];
          } else {
            // Create a new 'documents' key with the fileList
            fieldAmprahan[indexAmprahan]['documents'] = fileList;
          }
        } else {
          // Add a new map with 'documents' key if index is out of bounds
          fieldAmprahan.add({"documents": fileList});
        }
        fileList = [];
      } else {
        print('cancel');
        // User canceled the picker
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: gap),
      // padding: EdgeInsets.all(padding + 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius - 15),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding + 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormFieldCustom(
                  placeholder: '0525515518',
                  title: 'No Amprahan',
                  controller: noAmprahan,
                  onChanged: (value) {
                    if (indexAmprahan! < fieldAmprahan.length) {
                      fieldAmprahan[indexAmprahan] = {
                        ...fieldAmprahan[indexAmprahan],
                        "amprahan_number": value
                      };
                    } else {
                      fieldAmprahan.add({"amprahan_number": value});
                    }
                  },
                ),
                ButtonIcon(
                  icon: Icons.upload_file,
                  title: 'Upload file Dokumentasi Kegiatan',
                  label: 'Dokumentasi Kegiatan',
                  onTapFunction: () {
                    // uploadFile('activity_documentation');
                    _showFullModal(context);
                  },
                  placeholder: 'Silahkan upload format PDF',
                ),
                FormFieldCustom(
                  placeholder: 'Masukan Total Realisasi Anggaran',
                  title: 'Total Realisasi Anggaran',
                  controller: totalRealisasi,
                  onChanged: (value) {
                    if (indexAmprahan! < fieldAmprahan.length) {
                      fieldAmprahan[indexAmprahan] = {
                        ...fieldAmprahan[indexAmprahan],
                        "total_budget_realisation": value
                      };
                    } else {
                      fieldAmprahan.add({"total_budget_realisation": value});
                    }
                  },
                ),
                FormFieldCustom(
                  placeholder: 'Masukan Sumber Dana',
                  title: 'Sumber Dana',
                  controller: sumberDana,
                  onChanged: (value) {
                    if (indexAmprahan! < fieldAmprahan.length) {
                      fieldAmprahan[indexAmprahan] = {
                        ...fieldAmprahan[indexAmprahan],
                        "budget_source": value
                      };
                    } else {
                      fieldAmprahan.add({"budget_source": value});
                    }
                  },
                ),
                Row(
                  children: [
                    Text('PAJAK'),
                    SizedBox(
                      width: gap,
                    ),
                    Checkbox(
                      value: true,
                      onChanged: (value) {
                        setState(() {
                          pajak = !pajak;
                        });
                        if (indexAmprahan! < fieldAmprahan.length) {
                          fieldAmprahan[indexAmprahan] = {
                            ...fieldAmprahan[indexAmprahan],
                            "pajak": !pajak
                          };
                        } else {
                          fieldAmprahan.add({"pajak": !pajak});
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(8),
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.grey,
                // ),
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

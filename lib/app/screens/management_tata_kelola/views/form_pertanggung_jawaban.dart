import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/widgets/widget.dart';

class FormPertanggungJawaban extends ConsumerStatefulWidget {
  const FormPertanggungJawaban({
    super.key,
  });

  @override
  ConsumerState<FormPertanggungJawaban> createState() =>
      _FormPertanggungJawabanState();
}

class _FormPertanggungJawabanState
    extends ConsumerState<FormPertanggungJawaban> {
  List<Widget> formAmprahan = [];
  List fileListSK = [];

  void uploadFile(List fileList) async {
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
              "Kegiatan / Detail / Create",
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
                    uploadFile(fileListSK);
                  }),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: fileListSK.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(fileListSK[index]);
                    return Expanded(
                        child: Container(
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
                                  fileListSK[index]['name'],
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
                            onTap: () => removeFile(fileListSK, index),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ));
                  }),
              ButtonIcon(
                  label: 'Berita Acara',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file Berita Acara',
                  onTapFunction: () {
                    print(fileListSK.length);
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
                  return AmprahanWidget(remove: () {
                    print('Remove button tapped for item $index');
                  });
                },
              ),
              const SizedBox(
                height: gap,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    formAmprahan.add(AmprahanWidget());
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
                  // _showFullModal(context);
                  print(fileListSK);
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
              200), // how long it takes to popup dialog after button click
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
                "Modal",
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
            // child: Pdf,
          ),
        );
      },
    );
  }
}

class AmprahanWidget extends StatelessWidget {
  const AmprahanWidget({Key? key, void Function()? remove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    placeholder: '0525515518', title: 'No Amprahan'),
                ButtonIcon(
                  icon: Icons.upload_file,
                  title: 'Upload file Doku,emtasi Kegiatan',
                  label: 'Dokumentasi Kegiatan',
                  onTapFunction: () {},
                  placeholder: 'Silahkan upload format PDF',
                ),
                FormFieldCustom(
                    placeholder: 'Masukan Total Realisasi Anggaran',
                    title: 'Total Realisasi Anggaran'),
                const FormFieldCustom(
                    placeholder: 'Masukan Sumber Dana', title: 'Sumber Dana'),
                Row(
                  children: [
                    Text('PAJAK'),
                    SizedBox(
                      width: gap,
                    ),
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
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

class FormFieldCustom extends StatelessWidget {
  final String title;
  final String placeholder;
  final double? width;
  final IconData? icon;
  final bool? isMultiLine;
  const FormFieldCustom(
      {super.key,
      required this.placeholder,
      required this.title,
      this.icon,
      this.width,
      this.isMultiLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(
            height: gap - 2,
          ),
          TextFormField(
            validator: (String? arg) {
              if (arg!.length < 3) {
                return 'Email must be more than 2 charater';
              }
              return null;
            },
            controller: null,
            decoration: InputDecoration(
                hintText: placeholder,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: padding),
                prefixIcon: icon != null ? Icon(icon) : null),
            maxLines: null,
            minLines: isMultiLine ?? false ? 4 : 1,
            onSaved: (String? val) {
              // username.text = val ?? '';
            },
          ),
        ],
      ),
    );
  }
}

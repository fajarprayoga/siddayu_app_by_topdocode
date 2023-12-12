import 'package:flutter/material.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/widgets/widget.dart';

class FormTataKelola extends StatelessWidget {
  const FormTataKelola({
    super.key,
  });

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
              FormFieldCustom(
                title: 'Nama Kegiatan',
                placeholder: 'Masukan nama kegiatan',
              ),
              FormFieldCustom(
                  title: 'Tanggal Kegiatan',
                  placeholder: 'Masukan tanggal kegiatan',
                  icon: Icons.date_range),
              FormFieldCustom(
                title: 'Deskripsi Kegiatan',
                placeholder: 'Masukan deskripsi kegiatan',
                isMultiLine: true,
              ),
              ButtonIcon(
                  label: 'SK',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file SK',
                  onTapFunction: () {}),
              ButtonIcon(
                  label: 'Berita Acara',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file Berita Acara',
                  onTapFunction: () {}),
              ButtonIcon(
                  label: 'Optional (PBJ)',
                  placeholder: 'Silahkan upload format PDF',
                  icon: Icons.upload_file,
                  title: 'Upload file PBJ',
                  onTapFunction: () {}),
              Container(
                padding: EdgeInsets.all(padding + 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius - 15),
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.blueGrey,
                      //   blurRadius: 4,
                      //   offset: Offset(0, 1), // Posisi bayangan
                      // ),
                    ]),
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
                    FormFieldCustom(
                        placeholder: 'Masukan Sumber Dana',
                        title: 'Sumber Dana'),
                  ],
                ),
              ),
              SizedBox(
                height: gap,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text('Tambah Amprahan'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, onPrimary: Colors.black),
              ),
              // Checkbox(value: true, onChanged: (){})
            ],
          ),
        ),
      ),
    );
  }
}

class FormFieldCustom extends StatelessWidget {
  final String title;
  final String placeholder;
  final IconData? icon;
  final bool? isMultiLine;
  const FormFieldCustom(
      {super.key,
      required this.placeholder,
      required this.title,
      this.icon,
      this.isMultiLine});

  @override
  Widget build(BuildContext context) {
    return Container(
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

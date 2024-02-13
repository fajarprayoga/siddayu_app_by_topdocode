import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Helper {
  static Future<List<File>> pickFiles([List<String> extensions = const ['pdf']]) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: extensions);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    }

    return [];
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:todo_app/app/core/helpers/logg.dart';

class Utils {
  static Color hex(String code) {
    String color = code.replaceAll('#', '');

    // if color code length is 3, make complete color code
    if (color.length == 3) {
      color =
          '${color[0]}${color[0]}${color[1]}${color[1]}${color[2]}${color[2]}';
    }

    return Color(int.tryParse('0xff$color') ?? 0xff000000);
  }

  static bool scrollHasMax(ScrollController scrollController, dynamic max) {
    bool isMaxList = max is List;

    // If max is integer or double
    max = max is int ? max.toDouble() : max;

    if (isMaxList) {
      max as List;

      if (max.length == 1) max.add(max[0]);
      max = max.map((e) => e is int ? e.toDouble() : e).toList();
    }

    double maxT = isMaxList ? max[0] : max;
    double maxB = isMaxList ? max[1] : max;

    double pixel = scrollController.position.pixels;
    double maxPixel = scrollController.position.maxScrollExtent;
    return (pixel < -maxB || pixel > (maxPixel + maxT));
  }

  static String dateFormat(DateTime date,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(date);
  }

  static errorCatcher(e, StackTrace s, {bool tracing = false}) {
    if (tracing) {
      final frames = Trace.from(s).terse.frames;

      // Extracting relevant information from stack frames
      List<String> members = frames
          .take(5)
          .map((e) => '${e.member ?? 'Unknown'} (${e.line}:${e.column})')
          .toList();
      String member = members.join(', ');

      // Constructing the error message with trace information
      String message = '''$e
Try to check [$member]''';

      // Logging the error message
      logg(message, name: 'ERROR');
      return;
    }

    // Extracting relevant frames for error location
    List frames = Trace.current().frames,
        terseFrames = Trace.from(s).terse.frames;
    Frame frame = Trace.current().frames[frames.length > 1 ? 1 : 0],
        trace = Trace.from(s).terse.frames[terseFrames.length > 1 ? 1 : 0];

    String errorLocation = '${frame.member}', errorLine = '${trace.line}';

    // Logging the error message with error location
    logg('-- Error on $errorLocation (Line $errorLine), $e', name: 'ERROR');
  }

  static Future<List<File>> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    }

    return [];
  }
}

import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:todo_app/app/core/helpers/logg.dart';

class Utils {
  static String dateFormat(DateTime date, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(date);
  }

  static errorCatcher(e, StackTrace s, {bool tracing = false}) {
    if (tracing) {
      final frames = Trace.from(s).terse.frames;

      // Extracting relevant information from stack frames
      List<String> members = frames.take(5).map((e) => '${e.member ?? 'Unknown'} (${e.line}:${e.column})').toList();
      String member = members.join(', ');

      // Constructing the error message with trace information
      String message = '''$e
Try to check [$member]''';

      // Logging the error message
      logg(message, name: 'ERROR');
      return;
    }

    // Extracting relevant frames for error location
    List frames = Trace.current().frames, terseFrames = Trace.from(s).terse.frames;
    Frame frame = Trace.current().frames[frames.length > 1 ? 1 : 0], trace = Trace.from(s).terse.frames[terseFrames.length > 1 ? 1 : 0];

    String errorLocation = '${frame.member}', errorLine = '${trace.line}';

    // Logging the error message with error location
    logg('-- Error on $errorLocation (Line $errorLine), $e', name: 'ERROR');
  }
}

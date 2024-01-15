import 'package:flutter/material.dart';

extension CustomWidgetExtension on Widget {
  Widget sized({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }
}

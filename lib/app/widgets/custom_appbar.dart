import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final String? subtitle;
  const CustomAppbar({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Gfont.fs15.bold,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: Gfont.fs14,
          )
      ],
    ).start;
  }
}

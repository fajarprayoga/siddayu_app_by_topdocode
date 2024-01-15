import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

import '../core/constants/value.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final IconData? icon;
  const PrimaryButton(
    this.text, {
    super.key,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkTouch(
      onTap: onTap,
      color: primary,
      radius: Br.radius(8),
      padding: Ei.sym(v: 8, h: 15),
      child: Textr(
        text,
        icon: icon,
        style: Gfont.white,
      ),
    );
  }
}

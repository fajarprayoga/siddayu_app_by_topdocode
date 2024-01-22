import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class CustomTextfield extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  const CustomTextfield({super.key, this.hint, this.controller, this.keyboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LzTextField(
        hint: hint,
        controller: controller,
        keyboard: keyboard,
        border: Br.all(color: Colors.black38),
      ),
    ).lz.clip(all: 5);
  }
}

class CustomTextfield2 extends StatelessWidget {
  final String? label, hint;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final Function()? onTap;
  final IconData? suffixIcon;
  const CustomTextfield2(
      {super.key, this.label, this.hint, this.controller, this.keyboard, this.onTap, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Textr(label ?? '', style: Gfont.bold, margin: Ei.only(b: 8)),
          InkTouch(
            onTap: onTap,
            radius: Br.radius(8),
            border: Br.all(color: Colors.black38),
            child: Row(
              children: [
                Expanded(
                  child: LzTextField(
                    hint: hint,
                    controller: controller,
                    keyboard: keyboard,
                    enabled: onTap == null,
                  ),
                ),
                if (onTap != null)
                  Iconr(
                    suffixIcon ?? Ti.chevronDown,
                    padding: Ei.sym(h: 15),
                  )
              ],
            ),
          ),
        ],
      ).start,
    ).lz.clip(all: 7);
  }
}

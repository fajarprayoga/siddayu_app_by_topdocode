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

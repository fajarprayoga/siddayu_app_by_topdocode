import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazyui/lazyui.dart';

class CustomTextfield extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final List<TextInputFormatter> formatters;
  final dynamic Function(bool)? onFocus;
  final bool disabled;
  const CustomTextfield(
      {super.key,
      this.hint,
      this.controller,
      this.keyboard,
      this.formatters = const [],
      this.onFocus,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: disabled ? 'f1f1f1'.hex : Colors.white,
      child: LzTextField1(
        hint: hint,
        controller: controller,
        keyboard: keyboard,
        formatters: formatters,
        onFocus: onFocus,
        enabled: !disabled,
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
  final List<TextInputFormatter> formatters;

  const CustomTextfield2(
      {super.key,
      this.label,
      this.hint,
      this.controller,
      this.keyboard,
      this.onTap,
      this.suffixIcon,
      this.formatters = const []});

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
                    formatters: formatters,
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

class LzTextField1 extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboard;
  final TextInputAction? inputAction;
  final Function(String)? onSubmit, onChange;
  final Function(bool value)? onFocus;
  final bool autofocus, enabled, obsecure, showMaxLength;
  final FocusNode? node;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final int maxLength;
  final int? maxLines;
  final List<TextInputFormatter> formatters;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle, hintStyle;
  final TextSelectionControls? selectionControls;
  final Widget? prefixIcon, suffixIcon;
  final Color? prefixIconColor, suffixIconColor, backgroundColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Function(bool value)? listenKeyboard;

  const LzTextField1(
      {Key? key,
      this.hint,
      this.keyboard,
      this.inputAction,
      this.onSubmit,
      this.obsecure = false,
      this.onChange,
      this.onFocus,
      this.autofocus = false,
      this.showMaxLength = false,
      this.node,
      this.controller,
      this.textAlign,
      this.enabled = true,
      this.maxLength = 255,
      this.formatters = const [],
      this.padding,
      this.maxLines,
      this.textStyle,
      this.hintStyle,
      this.selectionControls,
      this.prefixIcon,
      this.prefixIconColor,
      this.suffixIcon,
      this.suffixIconColor,
      this.backgroundColor,
      this.border,
      this.borderRadius,
      this.listenKeyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = LazyUi.radius;
    FocusNode localNode = node ?? FocusNode();

    localNode.addListener(() {
      if (onFocus != null) onFocus!(localNode.hasFocus);
    });

    if (listenKeyboard != null) {
      listenKeyboard!(MediaQuery.of(context).viewInsets.bottom > 0);
    }

    TextField textField = TextField(
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      keyboardType: keyboard,
      textInputAction: inputAction,
      onSubmitted: onSubmit,
      onChanged: onChange,
      autofocus: autofocus,
      focusNode: localNode,
      obscureText: obsecure,
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.start,
      controller: controller,
      maxLines: maxLines ?? 1,
      minLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength < 1 ? 1 : maxLength), ...formatters],
      selectionControls: selectionControls,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor ?? Colors.black38,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor ?? Colors.black38,
        isDense: true,
        contentPadding: padding ?? Ei.sym(v: 13.5, h: 20),
        hintText: hint,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black38),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    return border == null && backgroundColor == null
        ? textField
        : Container(
            decoration: BoxDecoration(
                border: border, color: backgroundColor, borderRadius: borderRadius ?? BorderRadius.circular(radius)),
            child: textField,
          );
  }
}

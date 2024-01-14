import 'package:flutter/material.dart';
import 'package:todo_app/app/widgets/customs/iconr.dart';

import '../../core/helpers/shortcut.dart';

/// `Textr` is a versatile text widget in Flutter that supports custom styling, text alignment, and optional icon placement. It simplifies the creation of text with icons while providing extensive customization options.
///
/// Example usage:
/// ```dart
/// Textr(
///   text: 'Hello, Textr!',
///   style: TextStyle(fontSize: 16, color: Colors.black),
///   textAlign: TextAlign.center,
///   textDecoration: TextDirection.ltr,
///   overflow: TextOverflow.ellipsis,
///   icon: Icons.star,
///   iconStyle: IconStyle.leading,
///   padding: EdgeInsets.all(8),
///   color: Colors.blue,
/// )
/// ```

class Textr extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDecoration;
  final TextOverflow? overflow;
  final bool? softwrap;
  final int? maxLines;
  final EdgeInsetsGeometry? margin, padding;
  final BorderRadiusGeometry? radius;
  final BoxBorder? border;
  final Color? color;
  final double? width;
  final AlignmentGeometry? alignment;
  final IconData? icon;
  final IconStyle? iconStyle;

  const Textr(this.text,
      {Key? key,
      this.style,
      this.margin,
      this.padding,
      this.width,
      this.textAlign,
      this.radius,
      this.textDecoration,
      this.overflow,
      this.softwrap,
      this.maxLines,
      this.alignment,
      this.border,
      this.color,
      this.icon,
      this.iconStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget wrapper(Widget child) => Container(
        alignment: alignment,
        padding: padding,
        margin: margin,
        width: width,
        decoration:
            BoxDecoration(border: border, borderRadius: radius, color: color),
        child: child);

    Widget textWidget = Text(text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        softWrap: softwrap,
        maxLines: maxLines);

    if (icon != null) {
      double iconSize = iconStyle?.size ?? style?.fontSize ?? 15;
      bool asSuffix = iconStyle?.asSuffix ?? false;

      List<Widget> children = [
        Iconr(
          icon!,
          color: iconStyle?.color ?? style?.color,
          size: iconSize + 4,
          margin: asSuffix
              ? Ei.only(l: iconStyle?.space ?? 10)
              : Ei.only(r: iconStyle?.space ?? 10),
        ),
        Flexible(child: textWidget),
      ];

      Widget textIconWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: iconStyle?.position ?? Caa.start,
        children: asSuffix ? children.reversed.toList() : children,
      );

      return wrapper(textIconWidget);
    }

    return wrapper(
      Text(text,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          softWrap: softwrap,
          maxLines: maxLines),
    );
  }
}

/// Represents a set of style properties for an icon.
class IconStyle {
  /// The size of the icon. Can be `null` for no specific size.
  final double? size;

  /// The amount of space around the icon. Can be `null`.
  final double? space;

  /// The color of the icon. Can be `null` for the default color.
  final Color? color;

  /// The alignment or position of the icon within its container.
  /// Default value is `CrossAxisAlignment.start`.
  final CrossAxisAlignment position;

  /// Determines whether the icon should be used as a suffix.
  /// Default value is `false`.
  final bool asSuffix;

  /// Creates an instance of [IconStyle] with the specified style properties.
  const IconStyle({
    this.size,
    this.space,
    this.color,
    this.position = CrossAxisAlignment.start,
    this.asSuffix = false,
  });
}
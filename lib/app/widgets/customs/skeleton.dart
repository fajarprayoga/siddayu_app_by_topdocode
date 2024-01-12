import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/app/core/constants/color.dart';

/// `Skeleton` is a Flutter widget that provides a skeleton loading effect to indicate that content is loading or placeholders are being displayed. It can be used to create a visually appealing loading animation for various UI elements.
///
/// Example usage:
/// ```dart
/// Skeleton(
///   color: Colors.grey[300], // Base color of the skeleton.
///   darkColor: Colors.grey[200], // Optional darker shade for a more realistic effect.
///   radius: 8.0, // Border radius for the skeleton (optional).
///   margin: EdgeInsets.symmetric(vertical: 10.0), // Optional margin around the skeleton.
///   brightness: 1.0, // Brightness of the skeleton (optional).
/// )
/// ```
class Skeleton extends StatelessWidget {
  /// Base color of the skeleton.
  final Color color;

  /// Optional darker shade for a more realistic effect.
  final Color? darkColor;

  /// Border radius for the skeleton (optional).
  final double radius;

  /// Optional specific border radii for different sides (topLeft, topRight, bottomLeft, bottomRight).
  final CustomRadius? radiusOnly;

  /// Optional margin around the skeleton.
  final EdgeInsets? margin;

  /// Brightness of the skeleton (optional).
  final double brightness;

  /// [width, height], or [width:[min, max], height:[min, max]]
  final dynamic size;

  /// ``` dart
  /// Skeleton(size: 15); // width and height is 15
  /// Skeleton(size: [50, 15]); // width is 50, height is 15
  /// Skeleton(size: [[15, 50], 15]); // width is (min: 15, max: 50), height is 15
  /// Skeleton(size: [[15, 50], [5, 15]]); // width is (min: 15, max: 50), height is (min: 5, max: 15)
  /// Skeleton(size: [[15, 50], [5, 15]], radiusOnly: LzRadius());
  /// ```
  const Skeleton(
      {Key? key,
      this.color = Colors.black,
      this.darkColor,
      this.margin,
      this.size = const [50, 15],
      this.radius = 0,
      this.radiusOnly,
      this.brightness = .5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // default size
    num minW = 50, maxW = 50;
    num minH = 15, maxH = 15;

    bool isSizeList = size is List;

    if (isSizeList) {
      List sizes = size;

      // size.length < 2, eg: [50]
      if ((size as List).length < 2) sizes = [size[0], size[0]];

      bool isSizeWList = sizes[0] is List, isSizeHList = sizes[1] is List;

      // width
      if (isSizeWList) {
        minW = sizes[0][0];
        maxW = sizes[0][1];
      } else {
        minW = sizes[0];
        maxW = sizes[0];
      }

      // height
      if (isSizeHList) {
        minH = sizes[1][0];
        maxH = sizes[1][1];
      } else {
        minH = sizes[1];
        maxH = sizes[1];
      }
    } else {
      minW = maxW = minH =
          maxH = (size is int) ? (size as int).toDouble() : size as double;
    }

    // prevent brightness out of range
    double brightness = this.brightness < 0
        ? 0
        : this.brightness > 1
            ? 1
            : this.brightness;

    // base color
    double bs = brightness - .2;
    double bsOpacity = bs < 0
        ? 0
        : bs > 1
            ? 1
            : bs;

    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: (darkColor == null ? color : LzColors.inverse(darkColor!))
            .withOpacity(bsOpacity),
        highlightColor:
            (darkColor == null ? color : LzColors.inverse(darkColor!))
                .withOpacity(brightness),
        child: Container(
          width: [minW, maxW].numInRange(),
          height: [minH, maxH].numInRange(),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              color: (darkColor == null ? color : LzColors.inverse(darkColor!))
                  .withOpacity(brightness),
              borderRadius: radiusOnly != null
                  ? CustomRadius.getRadius(radiusOnly!)
                  : BorderRadius.circular(radius)),
        ),
      ),
    );
  }
}

extension SkeletonExtension on Skeleton {
  Widget iterate(int value,
      {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
        crossAxisAlignment: alignment,
        children: List.generate(value, (i) => this));
  }
}

///
/// * author: hunghd
/// * email: hunghd.yb@gmail.com
///
/// A package provides an easy way to add shimmer effect to Flutter application
///

///
/// An enum defines all supported directions of shimmer effect
///
/// * [ShimmerDirection.ltr] left to right direction
/// * [ShimmerDirection.rtl] right to left direction
/// * [ShimmerDirection.ttb] top to bottom direction
/// * [ShimmerDirection.btt] bottom to top direction
///
enum ShimmerDirection { ltr, rtl, ttb, btt }

///
/// A widget renders shimmer effect over [child] widget tree.
///
/// [child] defines an area that shimmer effect blends on. You can build [child]
/// from whatever [Widget] you like but there're some notices in order to get
/// exact expected effect and get better rendering performance:
///
/// * Use static [Widget] (which is an instance of [StatelessWidget]).
/// * [Widget] should be a solid color element. Every colors you set on these
/// [Widget]s will be overridden by colors of [gradient].
/// * Shimmer effect only affects to opaque areas of [child], transparent areas
/// still stays transparent.
///
/// [period] controls the speed of shimmer effect. The default value is 1500
/// milliseconds.
///
/// [direction] controls the direction of shimmer effect. The default value
/// is [ShimmerDirection.ltr].
///
/// [gradient] controls colors of shimmer effect.
///
/// [loop] the number of animation loop, set value of `0` to make animation run
/// forever.
///
/// [enabled] controls if shimmer effect is active. When set to false the animation
/// is paused
///
///
/// ## Pro tips:
///
/// * [child] should be made of basic and simple [Widget]s, such as [Container],
/// [Row] and [Column], to avoid side effect.
///
/// * use one [Shimmer] to wrap list of [Widget]s instead of a list of many [Shimmer]s
///
@immutable
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  const Shimmer({
    Key? key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  }) : super(key: key);

  ///
  /// A convenient constructor provides an easy and convenient way to create a
  /// [Shimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
  /// `highlightColor`.
  ///
  Shimmer.fromColors({
    Key? key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  })  : gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]),
        super(key: key);

  @override
  State<Shimmer> createState() => _ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(
        DiagnosticsProperty<Duration>('period', period, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<int>('loop', loop, defaultValue: 0));
  }
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0) {
          _controller.repeat();
        } else if (_count < widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => _Shimmer(
        direction: widget.direction,
        gradient: widget.gradient,
        percent: _controller.value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _Shimmer({
    Widget? child,
    required this.percent,
    required this.direction,
    required this.gradient,
  }) : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) {
      return;
    }
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}

class CustomRadius {
  final double tl, tr, bl, br;
  final double? tlr, blr, ltb, rtb, others, all;

  CustomRadius(
      {this.tl = 0,
      this.tr = 0,
      this.bl = 0,
      this.br = 0,
      this.tlr,
      this.blr,
      this.ltb,
      this.rtb,
      this.others,
      this.all});

  // convert LzRadius to BorderRadius
  static BorderRadius getRadius(CustomRadius radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(
          radius.all ?? radius.others ?? radius.tlr ?? radius.ltb ?? radius.tl),
      topRight: Radius.circular(
          radius.all ?? radius.others ?? radius.tlr ?? radius.rtb ?? radius.tr),
      bottomLeft: Radius.circular(
          radius.all ?? radius.others ?? radius.blr ?? radius.ltb ?? radius.bl),
      bottomRight: Radius.circular(
          radius.all ?? radius.others ?? radius.blr ?? radius.rtb ?? radius.br),
    );
  }
}

extension ListNumExtension on List<num> {
  /// ```dart
  /// [10, 50].numInRange() // 30.5
  /// ```
  numInRange([Type type = double]) {
    if (isEmpty) return 0;
    num start = this[0], end = length > 1 ? this[1] : this[0];
    num result = start + (Random().nextDouble() * (end - start));
    return result = type == int ? result.round() : result;
  }
}

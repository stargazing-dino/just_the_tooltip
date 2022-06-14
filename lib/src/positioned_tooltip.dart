import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/src/utils/get_axis_direction.dart';
import 'package:just_the_tooltip/src/utils/get_position_dependent_offset.dart';

typedef TailBuilder = Path Function(
  Offset point1,
  Offset point2,
  Offset point3,
);

class PositionedTooltip extends SingleChildRenderObjectWidget {
  const PositionedTooltip({
    Key? key,
    required Widget child,
    required this.margin,
    required this.targetSize,
    required this.target,
    required this.offset,
    required this.preferredDirection,
    required this.offsetToTarget,
    required this.borderRadius,
    required this.tailBaseWidth,
    required this.tailLength,
    required this.tailBuilder,
    required this.animatedTransitionBuilder,
    required this.textDirection,
    required this.backgroundColor,
    required this.shadow,
    required this.elevation,
    required this.scrollPosition,
  }) : super(key: key, child: child);

  final EdgeInsetsGeometry margin;

  final Offset target;

  final Size targetSize;

  final double offset;

  final AxisDirection preferredDirection;

  final Offset offsetToTarget;

  final BorderRadiusGeometry borderRadius;

  final double tailBaseWidth;

  final double tailLength;

  final TailBuilder tailBuilder;

  final AnimatedTransitionBuilder animatedTransitionBuilder;

  final TextDirection textDirection;

  final Color backgroundColor;

  final Shadow shadow;

  final double elevation;

  final ScrollPosition? scrollPosition;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPositionedTooltip(
      margin: margin,
      offset: offset,
      target: target,
      borderRadius: borderRadius,
      tailLength: tailLength,
      tailBaseWidth: tailBaseWidth,
      tailBuilder: tailBuilder,
      textDirection: textDirection,
      backgroundColor: backgroundColor,
      preferredDirection: preferredDirection,
      targetSize: targetSize,
      shadow: shadow,
      elevation: elevation,
      scrollPosition: scrollPosition,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPositionedTooltip renderObject,
  ) {
    renderObject
      ..margin = margin
      ..offset = offset
      ..target = target
      ..borderRadius = borderRadius
      ..tailLength = tailLength
      ..tailBuilder = tailBuilder
      ..tailBaseWidth = tailBaseWidth
      ..textDirection = textDirection
      ..backgroundColor = backgroundColor
      ..preferredDirection = preferredDirection
      ..targetSize = targetSize
      ..shadow = shadow
      ..elevation = elevation
      ..scrollPosition = scrollPosition;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(DiagnosticsProperty<Offset>('target', target));
    properties.add(DiagnosticsProperty<Size>('targetSize', targetSize));
    properties.add(DoubleProperty('offset', offset));
    properties.add(
      DiagnosticsProperty<AxisDirection>(
        'preferredDirection',
        preferredDirection,
      ),
    );
    properties
        .add(DiagnosticsProperty<Offset>('offsetToTarget', offsetToTarget));
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>('borderRadius', borderRadius),
    );
    properties.add(DoubleProperty('tailBaseWidth', tailBaseWidth));
    properties.add(DoubleProperty('tailLength', tailLength));
    properties.add(
      DiagnosticsProperty<AnimatedTransitionBuilder>(
        'animatedTransitionBuilder',
        animatedTransitionBuilder,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextDirection>('textDirection', textDirection),
    );
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<Shadow>('shadow', shadow));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(
      DiagnosticsProperty<ScrollPosition>('scrollPosition', scrollPosition),
    );
    properties
        .add(ObjectFlagProperty<TailBuilder>.has('tailBuilder', tailBuilder));
  }
}

class RenderPositionedTooltip extends RenderShiftedBox
    with DebugOverflowIndicatorMixin {
  RenderPositionedTooltip({
    RenderBox? child,
    required EdgeInsetsGeometry margin,
    required double offset,
    required Offset target,
    required BorderRadiusGeometry borderRadius,
    required double tailLength,
    required double tailBaseWidth,
    required TailBuilder tailBuilder,
    required TextDirection textDirection,
    required Color backgroundColor,
    required AxisDirection preferredDirection,
    required Size targetSize,
    required Shadow shadow,
    required double elevation,
    required ScrollPosition? scrollPosition,
  })  : _margin = margin,
        _offset = offset,
        _target = target,
        _borderRadius = borderRadius,
        _tailLength = tailLength,
        _tailBaseWidth = tailBaseWidth,
        _tailBuilder = tailBuilder,
        _textDirection = textDirection,
        _backgroundColor = backgroundColor,
        _preferredDirection = preferredDirection,
        _targetSize = targetSize,
        _shadow = shadow,
        _elevation = elevation,
        _scrollPosition = scrollPosition,
        super(child);

  late AxisDirection axisDirection;

  EdgeInsetsGeometry get margin => _margin;
  EdgeInsetsGeometry _margin;
  set margin(EdgeInsetsGeometry value) {
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  double get offset => _offset;
  double _offset;
  set offset(double value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsLayout();
  }

  Offset get target => _target;
  Offset _target;
  set target(Offset value) {
    if (_target == value) return;
    _target = value;
    markNeedsLayout();
  }

  BorderRadiusGeometry get borderRadius => _borderRadius;
  BorderRadiusGeometry _borderRadius;
  set borderRadius(BorderRadiusGeometry value) {
    if (_borderRadius == value) return;
    _borderRadius = value;
    markNeedsLayout();
  }

  double get tailLength => _tailLength;
  double _tailLength;
  set tailLength(double value) {
    if (_tailLength == value) return;
    _tailLength = value;
    markNeedsLayout();
  }

  double get tailBaseWidth => _tailBaseWidth;
  double _tailBaseWidth;
  set tailBaseWidth(double value) {
    if (_tailBaseWidth == value) return;
    _tailBaseWidth = value;
    markNeedsLayout();
  }

  TailBuilder get tailBuilder => _tailBuilder;
  TailBuilder _tailBuilder;
  set tailBuilder(TailBuilder value) {
    if (_tailBuilder == value) return;
    _tailBuilder = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  AxisDirection get preferredDirection => _preferredDirection;
  AxisDirection _preferredDirection;
  set preferredDirection(AxisDirection value) {
    if (_preferredDirection == value) return;
    _preferredDirection = value;
    markNeedsLayout();
  }

  Size get targetSize => _targetSize;
  Size _targetSize;
  set targetSize(Size value) {
    if (_targetSize == value) return;
    _targetSize = value;
    markNeedsLayout();
  }

  Shadow get shadow => _shadow;
  Shadow _shadow;
  set shadow(Shadow value) {
    if (_shadow == value) return;
    _shadow = value;
    markNeedsPaint();
  }

  double get elevation => _elevation;
  double _elevation;
  set elevation(double value) {
    if (_elevation == value) return;
    _elevation = value;
    markNeedsPaint();
  }

  ScrollPosition? get scrollPosition => _scrollPosition;
  ScrollPosition? _scrollPosition;
  set scrollPosition(ScrollPosition? value) {
    if (_scrollPosition == value) return;
    _scrollPosition = value;
    markNeedsLayout();
  }

  double get offsetAndTailLength => offset + tailLength;

  @override
  BoxConstraints get constraints => super.constraints.loosen();

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final maybeChild = child;
    final resolvedMargin = margin.resolve(textDirection);

    if (maybeChild == null) {
      return constraints.constrain(resolvedMargin.collapsedSize);
    }

    final childSize =
        maybeChild.getDryLayout(constraints.deflate(resolvedMargin));
    final newAxisDirection = getAxisDirection(
      targetSize: targetSize,
      target: target,
      preferredDirection: preferredDirection,
      offsetAndTail: offsetAndTailLength,
      margin: resolvedMargin,
      size: constraints.biggest,
      childSize: childSize,
      scrollPosition: scrollPosition,
    );
    final quadrantConstraints = _getQuadrantConstraints(
      constraints,
      newAxisDirection,
      scrollPosition,
      resolvedMargin,
    );

    return maybeChild.getDryLayout(quadrantConstraints);
  }

  @override
  void performLayout() {
    final maybeChild = child;
    final resolvedMargin = margin.resolve(textDirection);

    if (maybeChild == null) {
      size = constraints.constrain(resolvedMargin.collapsedSize);
      return;
    }

    // TODO:
    // final childSize = _child.getDryLayout(constraints.deflate(margin));
    // Until https://github.com/flutter/flutter/issues/71687 is fixed, we must
    // get child size via intrinsics :

    final deflated = constraints.deflate(resolvedMargin);
    final width = maybeChild.computeMinIntrinsicWidth(deflated.maxHeight);
    final height = maybeChild.computeMinIntrinsicHeight(deflated.maxWidth);
    final childSize = Size(width, height);

    axisDirection = getAxisDirection(
      targetSize: targetSize,
      target: target,
      preferredDirection: preferredDirection,
      offsetAndTail: offsetAndTailLength,
      margin: resolvedMargin,
      size: constraints.biggest,
      childSize: childSize,
      scrollPosition: scrollPosition,
    );
    final childParentData = maybeChild.parentData as BoxParentData;
    var quadrantConstraints = _getQuadrantConstraints(
      constraints,
      axisDirection,
      scrollPosition,
      resolvedMargin,
    );

    maybeChild.layout(
      quadrantConstraints,
      parentUsesSize: true,
    );

    final shrinkWrapWidth = constraints.maxWidth == double.infinity;
    final shrinkWrapHeight = constraints.maxHeight == double.infinity;

    size = constraints.constrain(
      Size(
        shrinkWrapWidth ? maybeChild.size.width : double.infinity,
        shrinkWrapHeight ? maybeChild.size.height : double.infinity,
      ),
    );

    final quadrantOffset = getPositionDependentOffset(
      axisDirection: axisDirection,
      childSize: maybeChild.size,
      margin: resolvedMargin,
      offsetAndTail: offsetAndTailLength,
      size: size,
      target: target,
      targetSize: targetSize,
      scrollPosition: scrollPosition,
    );

    childParentData.offset = quadrantOffset;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: add debug paint for overflows

    final maybeChild = child;

    if (maybeChild != null) {
      final childParentData = maybeChild.parentData! as BoxParentData;
      final parentDataOffset = childParentData.offset;
      final paint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      final path = Path();
      final radius = borderRadius.resolve(textDirection);
      final rect = (offset + parentDataOffset) & maybeChild.size;

      // TODO:
      // Currently, I don't think this is triggered by an empty child. Dunno
      // why this is the case or if this is a feature.
      if (!rect.isEmpty) {
        path
          ..addRRect(
            RRect.fromRectAndCorners(
              rect,
              topLeft: radius.topLeft,
              topRight: radius.topRight,
              bottomLeft: radius.bottomLeft,
              bottomRight: radius.bottomRight,
            ),
          )
          ..addPath(
            _paintTail(
              rect: rect,
              radius: radius,
            ),
            Offset.zero,
          );

        // TODO: What do I do about the blurSigma property on shadow?
        context.canvas.drawShadow(
          path.shift(shadow.offset),
          shadow.color,
          elevation,
          false,
        );
        context.canvas.drawPath(path, paint);
      }
    }

    super.paint(context, offset);
  }

  /// Constrains where the box is allowed to take space by
  /// conditionally squishing it against an axis.
  ///
  /// If we're in a list, let's account for the space before and after the
  /// viewport so we don't overflow when there's really space.
  BoxConstraints _getQuadrantConstraints(
    BoxConstraints constraints,
    AxisDirection direction,
    ScrollPosition? scrollPosition,
    EdgeInsets margin,
  ) {
    final targetHeightRadius = targetSize.height / 2;
    final targetWidthRadius = targetSize.width / 2;
    final scrollAxis = scrollPosition?.axis;

    switch (direction) {
      case AxisDirection.up:
      case AxisDirection.down:
        final maxWidth = constraints.maxWidth - margin.horizontal;
        final hasVerticalScroll =
            scrollPosition != null && scrollAxis == Axis.vertical;

        if (direction == AxisDirection.up) {
          final heightAvailable = target.dy +
              (hasVerticalScroll ? scrollPosition.extentBefore : 0.0);

          return constraints.copyWith(
            maxWidth: maxWidth,
            maxHeight: heightAvailable -
                targetHeightRadius -
                offsetAndTailLength -
                margin.top,
          );
        } else {
          final heightAvailable = constraints.maxHeight +
              (hasVerticalScroll ? scrollPosition.extentAfter : 0.0);

          return constraints.copyWith(
            maxWidth: maxWidth,
            maxHeight: heightAvailable -
                target.dy -
                targetHeightRadius -
                offsetAndTailLength -
                margin.bottom,
          );
        }
      case AxisDirection.left:
      case AxisDirection.right:
        final maxHeight = constraints.maxHeight - margin.vertical;
        final hasHorizontalScroll =
            scrollPosition != null && scrollAxis == Axis.horizontal;

        if (direction == AxisDirection.left) {
          final widthAvailable = target.dx +
              (hasHorizontalScroll ? scrollPosition.extentBefore : 0.0);

          return constraints.copyWith(
            maxHeight: maxHeight,
            maxWidth: widthAvailable -
                margin.left -
                targetWidthRadius -
                offsetAndTailLength,
          );
        } else {
          final widthAvailable = constraints.maxWidth +
              (hasHorizontalScroll ? scrollPosition.extentAfter : 0.0);

          return constraints.copyWith(
            maxHeight: maxHeight,
            maxWidth: widthAvailable -
                target.dx -
                margin.right -
                targetWidthRadius -
                offsetAndTailLength,
          );
        }
    }
  }

  Path _paintTail({
    required Rect rect,
    required BorderRadius radius,
  }) {
    // Clockwise around the triangle starting at the target center
    // point + offset
    double x = 0, y = 0, x2 = 0, y2 = 0, x3 = 0, y3 = 0;
    final targetWidthRadius = targetSize.width / 2;
    final targetHeightRadius = targetSize.height / 2;

    switch (axisDirection) {
      case AxisDirection.up:
        final baseLength = math.min(
          tailBaseWidth,
          (rect.right - rect.left) -
              (radius.bottomLeft.x + radius.bottomRight.x),
        );
        final halfBaseLength = baseLength / 2;
        final insetLeftCorner = rect.left + radius.bottomLeft.x;
        final insetRightCorner = rect.right - radius.bottomRight.x;

        if (insetLeftCorner > insetRightCorner) {
          // This happens when the content is so small, accounting for the
          // border radius messes up our measurements. Might as well not draw
          // a tail at this point
          break;
        }

        final offsetTarget = target.translate(0, -offset - targetHeightRadius);

        // assert(rect.bottom == _target.dy - tailLength);

        x = offsetTarget.dx;
        y = offsetTarget.dy;

        x2 = (math.min(offsetTarget.dx, insetRightCorner) - halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y2 = rect.bottom;

        x3 = (math.max(offsetTarget.dx, insetLeftCorner) + halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y3 = rect.bottom;
        break;
      case AxisDirection.down:
        final baseLength = math.min(
          tailBaseWidth,
          (rect.right - rect.left) - (radius.topLeft.x + radius.topRight.x),
        );
        final halfBaseLength = baseLength / 2;
        final insetLeftCorner = rect.left + radius.topLeft.x;
        final insetRightCorner = rect.right - radius.topRight.x;

        if (insetLeftCorner > insetRightCorner) break;

        final offsetTarget = target.translate(0, offset + targetHeightRadius);

        assert(rect.top == offsetTarget.dy + tailLength);

        x = offsetTarget.dx;
        y = offsetTarget.dy;

        x2 = (math.max(offsetTarget.dx, insetLeftCorner) + halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y2 = rect.top;

        x3 = (math.min(offsetTarget.dx, insetRightCorner) - halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y3 = rect.top;
        break;
      case AxisDirection.left:
        final baseLength = math.min(
          tailBaseWidth,
          (rect.bottom - rect.top) - (radius.topRight.y + radius.bottomRight.y),
        );
        final halfBaseLength = baseLength / 2;
        final insetTopCorner = rect.top + radius.topRight.y;
        final insetBottomCorner = rect.bottom - radius.bottomRight.y;

        if (insetBottomCorner < insetTopCorner) break;

        final offsetTarget = target.translate(-offset - targetWidthRadius, 0.0);

        assert(rect.right == offsetTarget.dx - tailLength);

        x = offsetTarget.dx;
        y = offsetTarget.dy;

        x2 = rect.right;
        y2 = (math.max(offsetTarget.dy, insetTopCorner) + halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);

        x3 = rect.right;
        y3 = (math.min(offsetTarget.dy, insetBottomCorner) - halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);

        break;
      case AxisDirection.right:
        final baseLength = math.min(
          tailBaseWidth,
          (rect.bottom - rect.top) - (radius.topLeft.y + radius.topRight.y),
        );

        final halfBaseLength = baseLength / 2;
        final insetBottomCorner = rect.bottom - radius.bottomLeft.y;
        final insetTopCorner = rect.top + radius.topLeft.y;

        if (insetBottomCorner < insetTopCorner) break;

        final offsetTarget = target.translate(offset + targetWidthRadius, 0.0);

        assert(rect.left == offsetTarget.dx + tailLength);

        x = offsetTarget.dx;
        y = offsetTarget.dy;

        x2 = rect.left;
        y2 = (math.min(offsetTarget.dy, insetBottomCorner) - halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);

        x3 = rect.left;
        y3 = (math.max(offsetTarget.dy, insetTopCorner) + halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);
        break;
    }

    return tailBuilder(Offset(x, y), Offset(x2, y2), Offset(x3, y3));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // TODO: Is it necessary to fill these twice, once in the parent and once
    // here?
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(DiagnosticsProperty<Offset>('target', target));
    properties.add(DiagnosticsProperty<Size>('targetSize', targetSize));
    properties.add(DoubleProperty('offset', offset));
    properties.add(
      DiagnosticsProperty<AxisDirection>(
        'preferredDirection',
        preferredDirection,
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>('borderRadius', borderRadius),
    );
    properties.add(DoubleProperty('tailBaseWidth', tailBaseWidth));
    properties.add(DoubleProperty('tailLength', tailLength));
    properties.add(
      DiagnosticsProperty<TextDirection>('textDirection', textDirection),
    );
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<Shadow>('shadow', shadow));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(EnumProperty<AxisDirection>('axisDirection', axisDirection));
    properties.add(
      DiagnosticsProperty<ScrollPosition?>('scrollPosition', scrollPosition),
    );
    properties
        .add(ObjectFlagProperty<TailBuilder>.has('tailBuilder', tailBuilder));
    properties.add(DoubleProperty('offsetAndTailLength', offsetAndTailLength));
  }
}

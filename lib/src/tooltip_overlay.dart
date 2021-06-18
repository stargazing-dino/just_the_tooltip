import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/src/horizontal_geometry.dart';
import 'package:just_the_tooltip/src/position_dependent_box.dart';
import 'package:just_the_tooltip/src/vertical_geometry.dart';

/// Getting the intrinsic size of the child was from [Align] and
/// [RenderPositionedBox]
class TooltipOverlay extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;

  final EdgeInsets margin;

  final Animation<double> animation;

  final Offset target;

  final Size targetSize;

  final double offset;

  final AxisDirection preferredDirection;

  final LayerLink link;

  final Offset offsetToTarget;

  final BorderRadiusGeometry borderRadius;

  final double tailBaseWidth;

  final double tailLength;

  final AnimatedTransitionBuilder animatedTransitionBuilder;

  final TextDirection textDirection;

  final Color backgroundColor;

  final Shadow shadow;

  final double elevation;

  const TooltipOverlay({
    Key? key,
    required Widget child,
    required this.padding,
    required this.margin,
    required this.animation,
    required this.targetSize,
    required this.target,
    required this.offset,
    required this.preferredDirection,
    required this.link,
    required this.offsetToTarget,
    required this.borderRadius,
    required this.tailBaseWidth,
    required this.tailLength,
    required this.animatedTransitionBuilder,
    required this.textDirection,
    required this.backgroundColor,
    required this.shadow,
    required this.elevation,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTooltipOverlay(
      margin: margin,
      offset: offset,
      target: target,
      borderRadius: borderRadius,
      tailLength: tailLength,
      tailBaseWidth: tailBaseWidth,
      textDirection: textDirection,
      backgroundColor: backgroundColor,
      preferredDirection: preferredDirection,
      targetSize: targetSize,
      shadow: shadow,
      elevation: elevation,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTooltipOverlay renderObject,
  ) {
    renderObject.copyWith(
      margin: margin,
      offset: offset,
      target: target,
      borderRadius: borderRadius,
      tailLength: tailLength,
      tailBaseWidth: tailBaseWidth,
      textDirection: textDirection,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties
        .add(DiagnosticsProperty<Animation<double>>('animation', animation));
    properties.add(DiagnosticsProperty<Offset>('target', target));
    properties.add(DiagnosticsProperty<Size>('targetSize', targetSize));
    properties.add(DoubleProperty('offset', offset));
    properties.add(
      DiagnosticsProperty<AxisDirection>(
        'preferredDirection',
        preferredDirection,
      ),
    );
    properties.add(DiagnosticsProperty<LayerLink>('link', link));
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
  }
}

class _RenderTooltipOverlay extends RenderShiftedBox {
  final EdgeInsets margin;

  final double offset;

  final Offset target;

  final BorderRadiusGeometry borderRadius;

  final double tailLength;

  final double tailBaseWidth;

  final TextDirection textDirection;

  final Color backgroundColor;

  final AxisDirection preferredDirection;

  final Size targetSize;

  final Shadow shadow;

  final double elevation;

  _RenderTooltipOverlay({
    RenderBox? child,
    required this.margin,
    required this.offset,
    required this.target,
    required this.borderRadius,
    required this.tailLength,
    required this.tailBaseWidth,
    required this.textDirection,
    required this.backgroundColor,
    required this.preferredDirection,
    required this.targetSize,
    required this.shadow,
    required this.elevation,
  }) : super(child);

  double get sumOffset => offset + tailLength;

  late AxisDirection axisDirection;

  @override
  void performLayout() {
    final constraints = this.constraints;
    final shrinkWrapWidth = constraints.maxWidth == double.infinity;
    final shrinkWrapHeight = constraints.maxHeight == double.infinity;
    final targetHeightRadius = targetSize.height / 2;
    final targetWidthRadius = targetSize.width / 2;
    final _child = child;

    if (_child != null) {
      final childParentData = _child.parentData! as BoxParentData;
      final deflated = constraints.copyWith(
        minWidth: margin.left,
        maxWidth: constraints.maxWidth - margin.right,
        minHeight: margin.top,
        maxHeight: constraints.maxHeight - margin.left,
      );
      _child.layout(
        deflated,
        parentUsesSize: true,
      );

      size = constraints.constrain(
        Size(
          shrinkWrapWidth ? _child.size.width : double.infinity,
          shrinkWrapHeight ? _child.size.height : double.infinity,
        ),
      );

      BoxConstraints quadrantConstrained;

      // TODO: Once you get the positioned box, relayout the child.
      // It's the right thing to do
      final positionBox = getPositionBoxForChild(
        size: size,
        childSize: _child.size,
      );

      switch (positionBox.axisDirection) {
        case AxisDirection.up:
          quadrantConstrained = deflated.copyWith(
            maxHeight: target.dy - targetHeightRadius - offset - tailLength,
          );
          break;
        case AxisDirection.down:
          final newConstraints = deflated.copyWith(
            maxHeight: deflated.maxHeight -
                target.dy -
                targetHeightRadius -
                offset -
                tailLength,
          );
          quadrantConstrained = newConstraints;
          break;
        case AxisDirection.left:
          quadrantConstrained = deflated.copyWith(
            maxWidth: target.dx - targetWidthRadius - offset - tailLength,
          );

          break;
        case AxisDirection.right:
          quadrantConstrained = deflated.copyWith(
            maxWidth: constraints.maxWidth -
                target.dx -
                targetWidthRadius -
                offset -
                tailLength,
          );
          break;
      }

      // We relayout because we for sure know which quadrant the child belongs
      _child.layout(
        quadrantConstrained,
        parentUsesSize: true,
      );

      axisDirection = positionBox.axisDirection;
      childParentData.offset = positionBox.offset;
    } else {
      size = constraints.constrain(
        Size(
          shrinkWrapWidth ? 0.0 : double.infinity,
          shrinkWrapHeight ? 0.0 : double.infinity,
        ),
      );
    }
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
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
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
  }

  PositionDependentBox getPositionBoxForChild({
    required Size size,
    required Size childSize,
  }) {
    switch (preferredDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        return verticalPositionDependentBox(
          size: size,
          targetSize: targetSize,
          childSize: childSize,
          target: target,
          verticalOffset: sumOffset,
          preferAbove: preferredDirection == AxisDirection.up,
          margin: margin,
        );
      case AxisDirection.left:
      case AxisDirection.right:
        return horizontalPositionDependentBox(
          size: size,
          targetSize: targetSize,
          childSize: childSize,
          target: target,
          horizontalOffset: sumOffset,
          preferLeft: preferredDirection == AxisDirection.left,
          margin: margin,
        );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final _child = child;

    if (_child != null) {
      context.canvas.save();
      context.canvas.translate(offset.dx, offset.dy);

      final childParentData = _child.parentData! as BoxParentData;
      final _offset = childParentData.offset;

      final paint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      final path = Path();
      final radius = borderRadius.resolve(textDirection);
      final rect = _offset & _child.size;

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

  _RenderTooltipOverlay copyWith({
    EdgeInsets? margin,
    double? offset,
    Offset? target,
    BorderRadiusGeometry? borderRadius,
    double? tailLength,
    double? tailBaseWidth,
    TextDirection? textDirection,
    // TODO: This just needs a markNeedsPaint
    Color? backgroundColor,
    AxisDirection? preferredDirection,
    Size? targetSize,
    // TODO: This just needs a markNeedsPaint
    Shadow? shadow,
    // TODO: This just needs a markNeedsPaint
    double? elevation,
  }) {
    markNeedsLayout();

    return _RenderTooltipOverlay(
      margin: margin ?? this.margin,
      offset: offset ?? this.offset,
      target: target ?? this.target,
      borderRadius: borderRadius ?? this.borderRadius,
      tailLength: tailLength ?? this.tailLength,
      tailBaseWidth: tailBaseWidth ?? this.tailBaseWidth,
      textDirection: textDirection ?? this.textDirection,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      preferredDirection: preferredDirection ?? this.preferredDirection,
      targetSize: targetSize ?? this.targetSize,
      shadow: shadow ?? this.shadow,
      elevation: elevation ?? this.elevation,
    );
  }

  Path _paintTail({
    required Rect rect,
    required BorderRadius radius,
  }) {
    final path = Path();

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

        final _target = target.translate(0, -offset - targetHeightRadius);

        // print('rect.bottom: ${rect.bottom}');
        // print('_target.dy: ${_target.dy}');
        // print('tailLength: $tailLength');
        // print('_target.dy - tailLength: ${_target.dy - tailLength}');
        // print(rect.bottom == _target.dy - tailLength);
        assert(rect.bottom == _target.dy - tailLength);

        x = _target.dx;
        y = _target.dy;

        x2 = (math.min(_target.dx, insetRightCorner) - halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y2 = rect.bottom;

        x3 = (math.max(_target.dx, insetLeftCorner) + halfBaseLength)
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

        final _target = target.translate(0, offset + targetHeightRadius);

        assert(rect.top == _target.dy + tailLength);

        x = _target.dx;
        y = _target.dy;

        x2 = (math.max(_target.dx, insetLeftCorner) + halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y2 = rect.top;

        x3 = (math.min(_target.dx, insetRightCorner) - halfBaseLength)
            .clamp(insetLeftCorner, insetRightCorner);
        y3 = rect.top;
        break;
      case AxisDirection.left:
        final baseLength = math.min(
          tailBaseWidth,
          (rect.bottom - rect.top) - (radius.topRight.y + radius.bottomRight.y),
        );
        final halfBaseLength = baseLength / 2;
        final insetBottomCorner = rect.bottom - radius.bottomRight.y;
        final insetTopCorner = rect.top + radius.topRight.y;

        if (insetBottomCorner > insetTopCorner) break;

        final _target = target.translate(-offset - targetWidthRadius, 0.0);

        assert(rect.right == _target.dx - tailLength);

        x = _target.dx;
        y = _target.dy;

        x2 = rect.right;
        y2 = (math.max(_target.dy, insetTopCorner) + halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);

        x3 = rect.right;
        y3 = (math.min(_target.dy, insetBottomCorner) - halfBaseLength)
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

        if (insetBottomCorner > insetTopCorner) break;

        final _target = target.translate(offset + targetWidthRadius, 0.0);

        assert(rect.left == _target.dx + tailLength);

        x = _target.dx;
        y = _target.dy;

        x2 = rect.left;
        y2 = (math.min(_target.dy, insetBottomCorner) - halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);

        x3 = rect.left;
        y3 = (math.max(_target.dy, insetTopCorner) + halfBaseLength)
            .clamp(insetTopCorner, insetBottomCorner);
        break;
    }

    return path
      ..moveTo(x, y)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
      ..close();
  }
}

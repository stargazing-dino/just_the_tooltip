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

  final double elevation;

  final BorderRadiusGeometry borderRadius;

  final double tailBaseWidth;

  final double tailLength;

  final AnimatedTransitionBuilder animatedTransitionBuilder;

  final TextDirection textDirection;

  final Color? backgroundColor;

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
    required this.elevation,
    required this.borderRadius,
    required this.tailBaseWidth,
    required this.tailLength,
    required this.animatedTransitionBuilder,
    required this.textDirection,
    required this.backgroundColor,
  }) : super(key: key, child: child);

  RenderObject createRenderObject(BuildContext context) {
    final _backgroundColor = backgroundColor ?? Theme.of(context).cardColor;

    return _RenderTooltipOverlay(
      margin: margin,
      offset: offset,
      target: target,
      borderRadius: borderRadius,
      tailLength: tailLength,
      tailBaseWidth: tailBaseWidth,
      textDirection: textDirection,
      backgroundColor: _backgroundColor,
      preferredDirection: preferredDirection,
      targetSize: targetSize,
    );
  }

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

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties
        .add(DiagnosticsProperty<Animation<double>>('animation', animation));
    // TODO:
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
  }) : super(child);

  double get sumOffset => offset + tailLength;

  late AxisDirection axisDirection;

  @override
  void performLayout() {
    final constraints = this.constraints;
    final shrinkWrapWidth = constraints.maxWidth == double.infinity;
    final shrinkWrapHeight = constraints.maxHeight == double.infinity;
    final _child = child;

    if (_child != null) {
      _child.layout(constraints.loosen(), parentUsesSize: true);
      size = constraints.constrain(Size(
        shrinkWrapWidth ? _child.size.width : double.infinity,
        shrinkWrapHeight ? _child.size.height : double.infinity,
      ));

      final positionBox = getPositionBoxForChild(
        size: size,
        childSize: _child.size,
      );
      axisDirection = positionBox.axisDirection;

      final childParentData = _child.parentData! as BoxParentData;

      childParentData.offset = positionBox.offset;
    } else {
      size = constraints.constrain(Size(
        shrinkWrapWidth ? 0.0 : double.infinity,
        shrinkWrapHeight ? 0.0 : double.infinity,
      ));
    }
  }

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
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

  void paint(PaintingContext context, Offset offset) {
    final _child = child;

    if (_child != null) {
      final childParentData = _child.parentData! as BoxParentData;
      final _offset = childParentData.offset;
      final totalOffset = offset + _offset;

      context.canvas.save();
      context.canvas.translate(totalOffset.dx, totalOffset.dy);

      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      final path = Path()..moveTo(_offset.dx, _offset.dy);
      final radius = borderRadius.resolve(textDirection);
      final rect = _offset & _child.size;

      path
        ..addRRect(RRect.fromRectAndCorners(
          rect,
          topLeft: radius.topLeft,
          topRight: radius.topRight,
          bottomLeft: radius.bottomLeft,
          bottomRight: radius.bottomRight,
        ));

      _paintTail(
        path: path,
        rect: rect,
        radius: radius,
      );

      context.canvas.drawPath(path, paint);
      context.canvas.restore();
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
    );
  }

  void _paintTail({
    required Path path,
    required Rect rect,
    required BorderRadius radius,
  }) {
    // Paint tail of tooltip
    // Clockwise: center point, right, left
    double x, y, x2, y2, x3, y3;

    switch (axisDirection) {
      case AxisDirection.up:
        final baseWidth = math.min(
          tailBaseWidth,
          (rect.right - rect.left) -
              (radius.bottomLeft.x + radius.bottomRight.x),
        );

        final halfBaseWidth = baseWidth / 2;
        final leftCorner = rect.left + radius.bottomLeft.x;
        final rightCorner = rect.right - radius.bottomRight.x;

        final _target = target.translate(0, -offset - margin.bottom);

        x = _target.dx;
        y = _target.dy - offset;

        x2 = math.min(_target.dx + halfBaseWidth, rightCorner);
        y2 = _target.dy - tailLength;

        x3 = math.max(_target.dx - halfBaseWidth, leftCorner);
        y3 = _target.dy - tailLength;
        break;
      case AxisDirection.down:
        final baseWidth = math.min(
          tailBaseWidth,
          (rect.right - rect.left) - (radius.topLeft.x + radius.topRight.x),
        );
        final halfBaseWidth = baseWidth / 2;
        final leftCorner = rect.left + radius.topLeft.x;
        final rightCorner = rect.right - radius.topRight.x;

        final _target = target.translate(0, offset + margin.top);

        x = _target.dx;
        y = _target.dy;

        x2 = math.min(
          math.max(_target.dx, leftCorner) + halfBaseWidth,
          rightCorner,
        );
        y2 = _target.dy + tailLength;

        x3 = math.max(
          math.min(_target.dx, rightCorner) - halfBaseWidth,
          leftCorner,
        );
        y3 = _target.dy + tailLength;
        break;
      case AxisDirection.left:
        final baseWidth = math.min(
          tailBaseWidth,
          (rect.bottom - rect.top) - (radius.topRight.y + radius.bottomRight.y),
        );

        final halfBaseWidth = baseWidth / 2;
        final bottomCorner = rect.bottom + radius.bottomRight.x;
        final topCorner = rect.top - radius.topRight.x;

        final _target = target.translate(-offset - margin.right, 0);

        x = _target.dx - offset;
        y = _target.dy;

        x2 = _target.dx - tailLength;
        y2 = math.max(_target.dy - halfBaseWidth, topCorner);

        x3 = _target.dx - tailLength;
        y3 = math.min(_target.dy + halfBaseWidth, bottomCorner);
        break;
      case AxisDirection.right:
        final baseWidth = math.min(
          tailBaseWidth,
          (rect.bottom - rect.top) - (radius.topLeft.y + radius.topRight.y),
        );

        final halfBaseWidth = baseWidth / 2;
        final bottomCorner = rect.bottom + radius.bottomLeft.x;
        final topCorner = rect.top - radius.topLeft.x;

        final _target = target.translate(offset + margin.left, 0.0);

        x = _target.dx + offset;
        y = _target.dy;

        x2 = _target.dx + tailLength;
        y2 = math.max(_target.dy - halfBaseWidth, topCorner);

        x3 = _target.dx + tailLength;
        y3 = math.min(_target.dy + halfBaseWidth, bottomCorner);
        break;
    }

    // print('---------');
    // print('(x, y) = ($x, $y)');
    // print('(x2, y2) = ($x2, $y2)');
    // print('(x3, y3) = ($x3, $y3)');
    // print('---------');

    path
      ..fillType = PathFillType.evenOdd
      ..moveTo(x, y)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
      ..close();
  }
}

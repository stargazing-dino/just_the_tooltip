import 'dart:math' as math;

import 'package:flutter/material.dart';

class MessageShape extends ShapeBorder {
  final Offset target;

  final BorderRadiusGeometry borderRadius;

  final double tailLength;

  final double tailBaseWidth;

  const MessageShape({
    required this.target,
    required this.borderRadius,
    required this.tailLength,
    required this.tailBaseWidth,
  });

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final radius = borderRadius.resolve(textDirection);

    return Path()
      ..addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: radius.topLeft,
        topRight: radius.topRight,
        bottomLeft: radius.bottomLeft,
        bottomRight: radius.bottomRight,
      ));
  }

  /// Draws the tail of the tooltip
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final radius = borderRadius.resolve(textDirection);
    double x, y, x2, y2, x3, y3;

    if (rect.bottomLeft.dy < target.dy && rect.bottomRight.dy < target.dy) {
      // AxisDirection.up
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.right - rect.left) - (radius.bottomLeft.x + radius.bottomRight.x),
      );

      x = target.dx - (baseWidth / 2);
      y = rect.bottom;

      x2 = baseWidth / 2;
      y2 = tailLength;

      x3 = baseWidth / 2;
      y3 = -tailLength;
    } else if (rect.topLeft.dy > target.dy && rect.topRight.dy > target.dy) {
      // AxisDirection.down
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.right - rect.left) - (radius.topLeft.x + radius.topRight.x),
      );

      x = target.dx - (baseWidth / 2);
      y = rect.top;

      x2 = baseWidth / 2;
      y2 = -tailLength;

      x3 = baseWidth / 2;
      y3 = tailLength;
    } else if (rect.topRight.dx < target.dx &&
        rect.bottomRight.dx < target.dx) {
      // AxisDirection.left
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.bottom - rect.top) - (radius.topRight.y + radius.bottomRight.y),
      );

      x = rect.right + tailLength;
      y = target.dy;

      x2 = -tailLength;
      y2 = baseWidth / 2;

      x3 = 0;
      y3 = -baseWidth;
    } else if (rect.topLeft.dx > target.dx && rect.bottomLeft.dx > target.dx) {
      // AxisDirection.right
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.bottom - rect.top) - (radius.topLeft.y + radius.topRight.y),
      );

      x = rect.left - tailLength;
      y = target.dy;

      x2 = tailLength;
      y2 = baseWidth / 2;

      x3 = 0;
      y3 = -baseWidth;
    } else {
      throw ArgumentError();
    }

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getInnerPath(rect), Offset.zero)
      ..moveTo(x, y)
      ..relativeLineTo(x2, y2)
      ..relativeLineTo(x3, y3)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: Does this even need to do anything?
  }

  // TODO:
  @override
  ShapeBorder scale(double t) => this;

  // TODO:
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
}

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

    // Clockwise: center point, right, left
    double x, y, x2, y2, x3, y3;

    if (rect.bottomLeft.dy < target.dy && rect.bottomRight.dy < target.dy) {
      // AxisDirection.up
      // TODO: double check this is clockwise
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.right - rect.left) - (radius.bottomLeft.x + radius.bottomRight.x),
      );

      final halfBaseWidth = baseWidth / 2;
      final leftCorner = rect.left + radius.bottomLeft.x;
      final rightCorner = rect.right - radius.bottomRight.x;

      x = target.dx;
      y = target.dy;

      x2 = math.min(target.dx + halfBaseWidth, rightCorner);
      y2 = target.dy - tailLength;

      x3 = math.max(target.dx - halfBaseWidth, leftCorner);
      y3 = target.dy - tailLength;
    } else if (rect.topLeft.dy > target.dy && rect.topRight.dy > target.dy) {
      // AxisDirection.down
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.right - rect.left) - (radius.topLeft.x + radius.topRight.x),
      );
      final halfBaseWidth = baseWidth / 2;
      final leftCorner = rect.left + radius.topLeft.x;
      final rightCorner = rect.right - radius.topRight.x;

      x = target.dx;
      y = target.dy;

      x2 = math.min(target.dx + halfBaseWidth, rightCorner);
      y2 = target.dy + tailLength;

      x3 = math.max(target.dx - halfBaseWidth, leftCorner);
      y3 = target.dy + tailLength;
    } else if (rect.topRight.dx < target.dx &&
        rect.bottomRight.dx < target.dx) {
      // AxisDirection.left
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.bottom - rect.top) - (radius.topRight.y + radius.bottomRight.y),
      );

      final halfBaseWidth = baseWidth / 2;
      final bottomCorner = rect.bottom + radius.bottomRight.x;
      final topCorner = rect.top - radius.topRight.x;

      x = target.dx;
      y = target.dy;

      x2 = target.dx - tailLength;
      y2 = math.max(target.dy - halfBaseWidth, topCorner);

      x3 = target.dx - tailLength;
      y3 = math.min(target.dy + halfBaseWidth, bottomCorner);
    } else if (rect.topLeft.dx > target.dx && rect.bottomLeft.dx > target.dx) {
      // AxisDirection.right
      final baseWidth = math.min(
        tailBaseWidth,
        (rect.bottom - rect.top) - (radius.topLeft.y + radius.topRight.y),
      );

      final halfBaseWidth = baseWidth / 2;
      final bottomCorner = rect.bottom + radius.bottomLeft.x;
      final topCorner = rect.top - radius.topLeft.x;

      x = target.dx;
      y = target.dy;

      x2 = target.dx + tailLength;
      y2 = math.max(target.dy - halfBaseWidth, topCorner);

      x3 = target.dx + tailLength;
      y3 = math.min(target.dy + halfBaseWidth, bottomCorner);
    } else {
      throw ArgumentError();
    }

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getInnerPath(rect), Offset.zero)
      ..moveTo(x, y)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
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

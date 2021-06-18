import 'package:flutter/material.dart';

AxisDirection getAxisDirection({
  required Size size,
  required Size targetSize,
  required Size childSize,
  required Offset target,
  required AxisDirection preferredDirection,
  required double offset,
  required EdgeInsets margin,
}) {
  switch (preferredDirection) {
    case AxisDirection.left:
    case AxisDirection.right:
      final preferLeft = preferredDirection == AxisDirection.left;
      final childAndOffsetWidth = offset + childSize.width;
      final targetWidthRadius = targetSize.width / 2;
      final rightTargetEdge = target.dx + targetWidthRadius;
      final leftTargetEdge = target.dx - targetWidthRadius;

      // LTE = leftTargetEdge
      // |margin.L          child+offset            LTE                           |
      final fitsLeft = leftTargetEdge - margin.left >= childAndOffsetWidth;

      //                                   size.width
      // |              RTE                      child+offset             margin.R|
      final fitsRight =
          size.width - rightTargetEdge - margin.right >= childAndOffsetWidth;

      final tooltipLeft =
          preferLeft ? fitsLeft || !fitsRight : !(fitsRight || !fitsLeft);

      return tooltipLeft ? AxisDirection.left : AxisDirection.right;

    case AxisDirection.up:
    case AxisDirection.down:
      final preferAbove = preferredDirection == AxisDirection.up;
      final childAndOffsetHeight = offset + childSize.height;
      final targetHeightRadius = targetSize.height / 2;
      final bottomTargetEdge = target.dy + targetHeightRadius;
      final topTargetEdge = target.dy - targetHeightRadius;

      final fitsAbove = topTargetEdge - margin.top >= childAndOffsetHeight;
      final fitsBelow = size.height - bottomTargetEdge - margin.bottom >=
          childAndOffsetHeight;
      final tooltipAbove =
          preferAbove ? fitsAbove || !fitsBelow : !(fitsBelow || !fitsAbove);

      return tooltipAbove ? AxisDirection.up : AxisDirection.down;
  }
}

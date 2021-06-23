import 'package:flutter/material.dart';

AxisDirection getAxisDirection({
  required Size size,
  required Size targetSize,
  required Size childSize,
  required Offset target,
  required AxisDirection preferredDirection,

  /// This should include both the offset and the tailLength
  required double offsetAndTail,
  required EdgeInsets margin,
  required ScrollPosition? scrollPosition,
}) {
  switch (preferredDirection) {
    case AxisDirection.left:
    case AxisDirection.right:
      final preferLeft = preferredDirection == AxisDirection.left;
      final childAndOffsetWidth = offsetAndTail + childSize.width;
      final targetWidthRadius = targetSize.width / 2;
      final rightTargetEdge = target.dx + targetWidthRadius;
      final leftTargetEdge = target.dx - targetWidthRadius;
      var spaceAvailableLeft = leftTargetEdge;
      var spaceAvailableRight = size.width - rightTargetEdge;

      if (scrollPosition != null && scrollPosition.axis == Axis.horizontal) {
        spaceAvailableLeft += scrollPosition.extentBefore;
        spaceAvailableRight += scrollPosition.extentAfter;
      }

      // LTE = leftTargetEdge
      // |margin.L          child+offset            LTE                           |
      var fitsLeft = spaceAvailableLeft - margin.left >= childAndOffsetWidth;

      //                                   size.width
      // |              RTE                      child+offset             margin.R|
      var fitsRight = spaceAvailableRight - margin.right >= childAndOffsetWidth;

      final tooltipLeft =
          preferLeft ? fitsLeft || !fitsRight : !(fitsRight || !fitsLeft);

      return tooltipLeft ? AxisDirection.left : AxisDirection.right;

    case AxisDirection.up:
    case AxisDirection.down:
      final preferAbove = preferredDirection == AxisDirection.up;
      final childAndOffsetHeight = offsetAndTail + childSize.height;
      final targetHeightRadius = targetSize.height / 2;
      final bottomTargetEdge = target.dy + targetHeightRadius;
      final topTargetEdge = target.dy - targetHeightRadius;
      var spaceAvailableAbove = topTargetEdge;
      var spaceAvailableBelow = size.height - bottomTargetEdge;

      if (scrollPosition != null && scrollPosition.axis == Axis.vertical) {
        spaceAvailableAbove += scrollPosition.extentBefore;
        spaceAvailableBelow += scrollPosition.extentAfter;
      }

      var fitsAbove = spaceAvailableAbove - margin.top >= childAndOffsetHeight;
      var fitsBelow =
          spaceAvailableBelow - margin.bottom >= childAndOffsetHeight;

      final tooltipAbove =
          preferAbove ? fitsAbove || !fitsBelow : !(fitsBelow || !fitsAbove);

      return tooltipAbove ? AxisDirection.up : AxisDirection.down;
  }
}

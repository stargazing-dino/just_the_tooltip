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
      final hasHorizontalScroll =
          scrollPosition != null && scrollPosition.axis == Axis.horizontal;

      // LTE = leftTargetEdge
      // |margin.L          child+offset            LTE                           |
      var fitsLeft = leftTargetEdge - margin.left >= childAndOffsetWidth;

      //                                   size.width
      // |              RTE                      child+offset             margin.R|
      var fitsRight =
          size.width - rightTargetEdge - margin.right >= childAndOffsetWidth;

      if (!fitsLeft && !fitsRight && hasHorizontalScroll) {
        // Because it doesn't fit in either direction, it's going to go the
        // preferredDirection. Let's check one last time if it fits in the
        // opposite direction though accounting for unviewable scroll space
        if (preferLeft) {
          fitsRight = (size.width + scrollPosition!.extentAfter) -
                  rightTargetEdge -
                  margin.right >=
              childAndOffsetWidth;
        } else {
          fitsLeft =
              (leftTargetEdge + scrollPosition!.extentBefore) - margin.left >=
                  childAndOffsetWidth;
        }
      }

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
      final hasVerticalScroll =
          scrollPosition != null && scrollPosition.axis == Axis.vertical;

      var fitsAbove = topTargetEdge - margin.top >= childAndOffsetHeight;
      var fitsBelow = size.height - bottomTargetEdge - margin.bottom >=
          childAndOffsetHeight;

      if (!fitsAbove && !fitsBelow && hasVerticalScroll) {
        if (preferAbove) {
          fitsBelow = (size.height + scrollPosition!.extentAfter) -
                  bottomTargetEdge -
                  margin.bottom >=
              childAndOffsetHeight;
        } else {
          fitsAbove =
              (topTargetEdge + scrollPosition!.extentBefore) - margin.top >=
                  childAndOffsetHeight;
        }
      }

      final tooltipAbove =
          preferAbove ? fitsAbove || !fitsBelow : !(fitsBelow || !fitsAbove);

      return tooltipAbove ? AxisDirection.up : AxisDirection.down;
  }
}

import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:just_the_tooltip/src/position_dependent_box.dart';

/// Position a child box within a container box, either left or right a target
/// point.
///
/// The container's size is described by `size`.
///
/// The target point is specified by `target`, as an offset from the top left of
/// the container.
///
/// The child box's size is given by `childSize`.
///
/// The return value is the suggested distance from the top left of the
/// container box to the top left of the child box.
///
/// The suggested position will be above the target point if `preferLeft` is
/// false, and left the target point if it is true, unless it wouldn't fit on
/// the preferred side but would fit on the other side.
///
/// The suggested position will place the nearest side of the child to the
/// target point `horizontalOffset` from the target point (even if it cannot fit
/// given that constraint).
///
/// The suggested position will be at least `margin` away from the edge of the
/// container. If possible, the child will be positioned so that its center is
/// aligned with the target point. If the child cannot fit vertically within
/// the container given the margin, then the child will be centered in the
/// container.
///
/// Used by [Tooltip] to position a tooltip relative to its parent.
///
/// The arguments must not be null.
PositionDependentBox horizontalPositionDependentBox({
  required Size size,
  required Size targetSize,
  required Size childSize,
  required Offset target,
  required bool preferLeft,
  required double horizontalOffset,
  required EdgeInsets margin,
}) {
  final childAndOffsetWidth = horizontalOffset + childSize.width;
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

  double x;
  if (tooltipLeft) {
    x = math.max(margin.left, leftTargetEdge - childAndOffsetWidth);
  } else {
    x = math.min(rightTargetEdge + horizontalOffset, size.width - margin.right);
  }

  // VERTICAL DIRECTION
  double y;
  // If the childSize is greater than the screen space available to it
  // then center it
  if (size.height - margin.vertical < childSize.height) {
    y = (size.height - childSize.height) / 2.0;
  } else {
    final normalizedTargetY =
        target.dy.clamp(margin.top, size.height - margin.bottom);
    final edge = (margin.bottom + childSize.height) / 2.0;
    if (normalizedTargetY < edge) {
      y = margin.bottom;
    } else if (normalizedTargetY > size.height - edge) {
      y = size.height - margin.bottom - childSize.height;
    } else {
      y = normalizedTargetY - childSize.height / 2.0;
    }
  }

  return PositionDependentBox(
    offset: Offset(x, y),
    axisDirection: tooltipLeft ? AxisDirection.left : AxisDirection.right,
  );
}

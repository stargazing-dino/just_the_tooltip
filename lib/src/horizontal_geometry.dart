import 'dart:math' as math;

import 'package:flutter/painting.dart';

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
Offset horizontalPositionDependentBox({
  required Size size,
  required Size childSize,
  required Offset target,
  required bool left,
  double horizontalOffset = 0.0,
  double margin = 10.0,
}) {
  if (left) {
    margin *= -1;
  }
  // HORIZONTAL DIRECTION
  // final fitsLeft =
  //     target.dx + horizontalOffset + childSize.width <= size.width - margin;
  // final fitsRight = target.dx - horizontalOffset - childSize.width >= margin;
  // final tooltipLeft =
  //     preferLeft ? fitsLeft || !fitsRight : !(fitsRight || !fitsLeft);
  double x;
  if (left) {
    x = math.max(target.dx - horizontalOffset - childSize.width, margin);
  } else {
    x = math.min(target.dx + horizontalOffset, size.width - margin);
  }

  // VERTICAL DIRECTION
  double y;
  if (size.height - margin * 2.0 < childSize.height) {
    y = (size.height - childSize.height) / 2.0;
  } else {
    final normalizedTargetY = target.dy.clamp(margin, size.height - margin);
    final edge = margin + childSize.height / 2.0;
    if (normalizedTargetY < edge) {
      y = margin;
    } else if (normalizedTargetY > size.height - edge) {
      y = size.height - margin - childSize.height;
    } else {
      y = normalizedTargetY - childSize.height / 2.0;
    }
  }
  return Offset(x, y);
}

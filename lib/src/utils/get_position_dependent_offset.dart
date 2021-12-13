// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Position a child box within a container box.
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
/// The suggested position will place the nearest side of the child to the
/// target point `verticalOffset` from the target point (even if it cannot fit
/// given that constraint).
///
/// The suggested position will be at least `margin` away from the edge of the
/// container. If possible, the child will be positioned so that its center is
/// aligned with the target point. If the child cannot fit horizontally within
/// the container given the margin, then the child will be centered in the
/// container.
///
Offset getPositionDependentOffset({
  required Size size,
  required Size targetSize,
  required Size childSize,
  required Offset target,
  required AxisDirection axisDirection,
  required double offsetAndTail,
  required EdgeInsets margin,
  required ScrollPosition? scrollPosition,
}) {
  switch (axisDirection) {
    case AxisDirection.down:
    case AxisDirection.up:
      final tooltipAbove = axisDirection == AxisDirection.up;
      final childAndOffsetHeight = offsetAndTail + childSize.height;
      final targetHeightRadius = targetSize.height / 2;
      final bottomTargetEdge = target.dy + targetHeightRadius;
      final topTargetEdge = target.dy - targetHeightRadius;
      final hasVerticalScroll =
          scrollPosition != null && scrollPosition.axis == Axis.vertical;

      double y;
      if (tooltipAbove) {
        if (hasVerticalScroll) {
          y = topTargetEdge - childAndOffsetHeight;
        } else {
          y = math.max(margin.top, topTargetEdge - childAndOffsetHeight);
        }
      } else {
        if (hasVerticalScroll) {
          y = bottomTargetEdge + offsetAndTail;
        } else {
          y = math.min(
            bottomTargetEdge + offsetAndTail,
            size.height - margin.top,
          );
        }
      }

      // HORIZONTAL DIRECTION
      double x;
      if (size.width - margin.horizontal < childSize.width) {
        x = math.max(margin.left, (size.width - childSize.width) / 2.0);
      } else {
        final normalizedTargetX = target.dx.clamp(
          margin.left,
          size.width - margin.right,
        );
        final edge = margin.left + childSize.width / 2.0;

        if (normalizedTargetX < edge) {
          x = margin.left;
        } else if (normalizedTargetX > size.width - edge) {
          x = size.width - margin.left - childSize.width;
        } else {
          x = normalizedTargetX - childSize.width / 2.0;
        }
      }

      return Offset(x, y);
    case AxisDirection.left:
    case AxisDirection.right:
      final tooltipLeft = axisDirection == AxisDirection.left;
      final childAndOffsetWidth = offsetAndTail + childSize.width;
      final targetWidthRadius = targetSize.width / 2;
      final rightTargetEdge = target.dx + targetWidthRadius;
      final leftTargetEdge = target.dx - targetWidthRadius;
      final hasHorizontalScroll =
          scrollPosition != null && scrollPosition.axis == Axis.horizontal;

      double x;
      if (tooltipLeft) {
        if (hasHorizontalScroll) {
          x = leftTargetEdge - childAndOffsetWidth;
        } else {
          x = math.max(margin.left, leftTargetEdge - childAndOffsetWidth);
        }
      } else {
        if (hasHorizontalScroll) {
          x = rightTargetEdge + offsetAndTail;
        } else {
          x = math.min(
            rightTargetEdge + offsetAndTail,
            size.width - margin.right,
          );
        }
      }

      // VERTICAL DIRECTION
      double y;
      if (size.height - margin.vertical < childSize.height) {
        y = (size.height - childSize.height) / 2.0;
      } else {
        final normalizedTargetY = target.dy.clamp(
          margin.top,
          size.height - margin.bottom,
        );
        final edge = (margin.bottom + childSize.height) / 2.0;

        if (normalizedTargetY < edge) {
          y = margin.bottom;
        } else if (normalizedTargetY > size.height - edge) {
          y = size.height - margin.bottom - childSize.height;
        } else {
          y = normalizedTargetY - childSize.height / 2.0;
        }
      }

      return Offset(x, y);
  }
}

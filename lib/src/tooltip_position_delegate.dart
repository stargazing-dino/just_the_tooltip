import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/horizontal_geometry.dart';
import 'package:just_the_tooltip/src/vertical_geometry.dart';

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class TooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// The size of the child to be displayed. This is used to compute
  /// the offset of the tooltip
  final Size boxSize;

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double offset;

  /// The length of the tail or pointer. This is added to the vertical offset
  /// in order to find the position of the tooltip
  final double tailLength;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final AxisDirection preferredDirection;

  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  const TooltipPositionDelegate({
    required this.boxSize,
    required this.target,
    required this.offset,
    required this.tailLength,
    required this.preferredDirection,
  });

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferredDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        return verticalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: offset + (boxSize.height / 2) + tailLength / 2,
          preferBelow: preferredDirection == AxisDirection.down,
        );
      case AxisDirection.left:
      case AxisDirection.right:
        return horizontalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          preferLeft: preferredDirection == AxisDirection.left,
          horizontalOffset: offset + (boxSize.height / 2) + tailLength / 2,
        );
      default:
        throw ArgumentError.value(preferredDirection);
    }
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  bool shouldRelayout(TooltipPositionDelegate oldDelegate) {
    // TODO: Shouldn't I check all values or just simply return true?
    return target != oldDelegate.target ||
        offset != oldDelegate.offset ||
        preferredDirection != oldDelegate.preferredDirection;
  }
}

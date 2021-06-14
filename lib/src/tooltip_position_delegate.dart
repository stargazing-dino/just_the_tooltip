import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/horizontal_geometry.dart';
import 'package:just_the_tooltip/src/vertical_geometry.dart';

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final ValueListenable<RenderBox?> child;

  /// The size of the child to be displayed. This is used to compute
  /// the offset of the tooltip
  final Size boxSize;

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip
  final double offset;

  /// The length of the tail or pointer. This is added to the vertical offset
  /// in order to find the position of the tooltip
  final double tailLength;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction
  final AxisDirection preferredDirection;

  final double margin;

  /// This is set during [getConstraintsForChild] and is used in
  /// [getPositionForChild] to know the definitive direction
  // AxisDirection? _direction;

  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  const TooltipPositionDelegate({
    required this.child,
    required this.boxSize,
    required this.target,
    required this.offset,
    required this.tailLength,
    required this.preferredDirection,
    required this.margin,
  }) : super(relayout: child);

  @override // 2
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    var loosenedConstraints = constraints.loosen();
    final _child = child.value;

    if (_child != null) {
      final childSize = _child.getDryLayout(loosenedConstraints);
      final offsetAndTail = tailLength + offset;
      final axisDirection = _getFinalAxisDirection(
        constraints.biggest,
        childSize,
      );

      switch (axisDirection) {
        case AxisDirection.down:
          final maxHeight =
              loosenedConstraints.maxHeight - (target.dy + offsetAndTail);
          loosenedConstraints = loosenedConstraints.copyWith(
            maxHeight: maxHeight,
          );
          break;
        case AxisDirection.up:
          final maxHeight =
              loosenedConstraints.maxHeight - (target.dy + offsetAndTail);
          loosenedConstraints = loosenedConstraints.copyWith(
            maxHeight: maxHeight,
          );
          break;
        case AxisDirection.left:
          final maxWidth =
              loosenedConstraints.maxWidth - (target.dx + offsetAndTail);
          loosenedConstraints = loosenedConstraints.copyWith(
            maxWidth: maxWidth,
          );
          break;
        case AxisDirection.right:
          final maxWidth =
              loosenedConstraints.maxWidth - (target.dx + offsetAndTail);
          loosenedConstraints = loosenedConstraints.copyWith(
            maxWidth: maxWidth,
          );
          break;
      }

      return loosenedConstraints;
    }

    return loosenedConstraints;
  }

  @override // 3
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferredDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        return verticalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: tailLength,
          preferBelow: preferredDirection == AxisDirection.down,
          margin: margin,
        );
      case AxisDirection.left:
      case AxisDirection.right:
        return horizontalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          horizontalOffset: tailLength,
          preferLeft: preferredDirection == AxisDirection.left,
          margin: margin,
        );
    }
  }

  AxisDirection _getFinalAxisDirection(Size size, Size childSize) {
    switch (preferredDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        return isBelow(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: offset,
          preferBelow: preferredDirection == AxisDirection.down,
          margin: margin,
        )
            ? AxisDirection.down
            : AxisDirection.up;
      case AxisDirection.left:
      case AxisDirection.right:
        return isLeft(
          size: size,
          childSize: childSize,
          target: target,
          horizontalOffset: offset,
          preferLeft: preferredDirection == AxisDirection.left,
          margin: margin,
        )
            ? AxisDirection.left
            : AxisDirection.right;
    }
  }

  @override
  bool shouldRelayout(TooltipPositionDelegate oldDelegate) {
    // TODO: Shouldn't I check all values or just simply return true?
    return target != oldDelegate.target ||
        offset != oldDelegate.offset ||
        preferredDirection != oldDelegate.preferredDirection;
  }
}

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

  /// This is set during [getConstraintsForChild] and is used in
  /// [getPositionForChild] to know the definitive direction
  AxisDirection? _direction;

  double? _offset;

  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  TooltipPositionDelegate({
    required this.boxSize,
    required this.target,
    required this.offset,
    required this.tailLength,
    required this.preferredDirection,
  });

  @override // 1
  Size getSize(BoxConstraints constraints) {
    return super.getSize(constraints);
  }

  @override // 2
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    switch (preferredDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        final verticalOffset = offset + (boxSize.height / 2) + tailLength / 2;
        _offset = verticalOffset;
        final margin = 10.0;
        final fitsBelow = target.dy + verticalOffset + boxSize.height <=
            constraints.maxHeight - margin;
        final fitsAbove = target.dy - verticalOffset - boxSize.height >= margin;
        final preferBelow = preferredDirection == AxisDirection.down;
        final tooltipBelow =
            preferBelow ? fitsBelow || !fitsAbove : !(fitsAbove || !fitsBelow);

        if (tooltipBelow) {
          _direction = AxisDirection.down;
          return constraints.loosen().copyWith(
              maxHeight: constraints.maxHeight -
                  target.dy +
                  (boxSize.height / 2) +
                  margin);
        } else {
          _direction = AxisDirection.up;
          return constraints
              .loosen()
              .copyWith(maxHeight: target.dy - (boxSize.height / 2) - margin);
        }
      case AxisDirection.left:
      case AxisDirection.right:
        final horizontalOffset = offset + (boxSize.height / 2) + tailLength / 2;
        _offset = horizontalOffset;
        final margin = 10.0;
        final fitsLeft = target.dx + horizontalOffset + boxSize.width <=
            constraints.maxWidth - margin;
        final fitsRight =
            target.dx - horizontalOffset - boxSize.width >= margin;
        final preferLeft = preferredDirection == AxisDirection.left;
        final tooltipLeft =
            preferLeft ? fitsLeft || !fitsRight : !(fitsRight || !fitsLeft);

        if (tooltipLeft) {
          _direction = AxisDirection.left;
          final _constraints = constraints.loosen().copyWith(
                maxWidth: target.dx - (boxSize.width / 2) - margin,
              );
          return _constraints;
        } else {
          _direction = AxisDirection.right;
          final _constraints = constraints.loosen().copyWith(
                maxWidth: constraints.maxWidth -
                    target.dx -
                    (boxSize.width / 2) -
                    margin,
              );
          return _constraints;
        }
      default:
        throw ArgumentError.value(preferredDirection);
    }
  }

  @override // 3
  Offset getPositionForChild(Size size, Size childSize) {
    switch (_direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        return verticalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          verticalOffset: _offset!,
          below: _direction == AxisDirection.down,
        );
      case AxisDirection.left:
      case AxisDirection.right:
        return horizontalPositionDependentBox(
          size: size,
          childSize: childSize,
          target: target,
          horizontalOffset: _offset!,
          left: _direction == AxisDirection.left,
        );
      default:
        throw ArgumentError.value(preferredDirection);
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

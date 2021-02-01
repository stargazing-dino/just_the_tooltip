library simple_tooltip;

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/message_shape.dart';
import 'package:just_the_tooltip/src/tooltip_position_delegate.dart';

class TooltipOverlay extends StatelessWidget {
  final Widget content;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final Animation<double> animation;

  final Size boxSize;

  final Offset target;

  final double offset;

  final AxisDirection preferredDirection;

  final LayerLink link;

  final Offset offsetToTarget;

  final double elevation;

  final BorderRadiusGeometry borderRadius;

  final double tailBaseWidth;

  final double tailLength;

  final Color? color;

  const TooltipOverlay({
    Key? key,
    required this.content,
    required this.padding,
    required this.margin,
    required this.animation,
    required this.boxSize,
    required this.target,
    required this.offset,
    required this.preferredDirection,
    required this.link,
    required this.offsetToTarget,
    required this.elevation,
    required this.borderRadius,
    required this.tailBaseWidth,
    required this.tailLength,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this transition for generic.
    // Should this even have an animation? Is it this widget's responsibility
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        // TODO: following anchor and target anchor
        offset: offsetToTarget,
        child: CustomSingleChildLayout(
          delegate: TooltipPositionDelegate(
            boxSize: boxSize,
            target: target,
            offset: offset,
            tailLength: tailLength,
            preferredDirection: preferredDirection,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: padding,
              margin: margin,
              child: content,
              decoration: ShapeDecoration(
                color: color ?? Theme.of(context).cardColor,
                shadows: kElevationToShadow[elevation],
                shape: MessageShape(
                  target: target,
                  borderRadius: borderRadius,
                  tailBaseWidth: tailBaseWidth,
                  tailLength: tailLength,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

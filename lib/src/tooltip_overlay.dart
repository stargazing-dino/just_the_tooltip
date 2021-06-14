library simple_tooltip;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:just_the_tooltip/src/tooltip_position_delegate.dart';

class TooltipOverlay extends StatefulWidget {
  final Widget content;

  final EdgeInsets padding;

  final double margin;

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

  final AnimatedTransitionBuilder animatedTransitionBuilder;

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
    required this.animatedTransitionBuilder,
    required this.color,
  }) : super(key: key);

  @override
  State<TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<TooltipOverlay> {
  final _key = GlobalKey();
  final child = ValueNotifier<RenderBox?>(null);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      _setRenderBox();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setRenderBox();
    super.didChangeDependencies();
  }

  void _setRenderBox() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;

    child.value = renderBox;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return widget.animatedTransitionBuilder(
          context,
          widget.animation,
          child,
        );
      },
      child: CompositedTransformFollower(
        link: widget.link,
        showWhenUnlinked: false,
        // TODO: expose following anchor and target anchor
        offset: widget.offsetToTarget,
        child: CustomSingleChildLayout(
          delegate: TooltipPositionDelegate(
            child: child,
            boxSize: widget.boxSize,
            target: widget.target,
            offset: widget.offset,
            tailLength: widget.tailLength,
            preferredDirection: widget.preferredDirection,
            margin: widget.margin,
          ),
          child: Material(
            key: _key,
            type: MaterialType.transparency,
            child: Container(
              padding: widget.padding,
              child: widget.content,
              decoration: ShapeDecoration(
                color: widget.color ?? Theme.of(context).cardColor,
                shadows: kElevationToShadow[widget.elevation],
                shape: MessageShape(
                  target: widget.target,
                  borderRadius: widget.borderRadius,
                  tailBaseWidth: widget.tailBaseWidth,
                  tailLength: widget.tailLength,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/just_the_tooltip_area.dart';
import 'package:just_the_tooltip/src/models/just_the_handler.dart';
import 'package:just_the_tooltip/src/models/just_the_interface.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

class JustTheTooltipEntry extends StatefulWidget with JustTheInterface {
  @override
  final Widget content;

  @override
  final Widget child;

  @override
  final AxisDirection preferredDirection;

  @override
  final Duration fadeInDuration;

  @override
  final Duration fadeOutDuration;

  @override
  final Curve curve;

  @override
  final EdgeInsets padding;

  @override
  final EdgeInsets margin;

  @override
  final double offset;

  @override
  final double elevation;

  @override
  final BorderRadiusGeometry borderRadius;

  @override
  final double tailLength;

  @override
  final double tailBaseWidth;

  /// These directly affect the constraints of the tooltip
  // BoxConstraints constraints;

  @override
  final AnimatedTransitionBuilder animatedTransitionBuilder;

  @override
  final Color? backgroundColor;

  @override
  final TextDirection textDirection;

  @override
  final Shadow? shadow;

  @override
  final bool showWhenUnlinked;

  final ScrollController? scrollController;

  static SingleChildRenderObjectWidget defaultAnimatedTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Widget? child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  const JustTheTooltipEntry({
    Key? key,
    required this.content,
    required this.child,
    this.preferredDirection = AxisDirection.down,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 0),
    this.curve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(8.0),
    this.offset = 0.0,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.tailLength = 16.0,
    this.tailBaseWidth = 32.0,
    this.animatedTransitionBuilder = defaultAnimatedTransitionBuilder,
    this.backgroundColor,
    this.textDirection = TextDirection.ltr,
    this.shadow,
    this.showWhenUnlinked = false,
    this.scrollController,
  }) : super(key: key);

  @override
  State<JustTheTooltipEntry> createState() => _JustTheTooltipEntryState();
}

class _JustTheTooltipEntryState extends State<JustTheTooltipEntry> {
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showTooltip,
        child: widget.child,
      ),
    );
  }

  void _showTooltip() {
    final tooltipArea = JustTheTooltipArea.of(context);
    final targetInformation = getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );

    tooltipArea.buildChild(
      withAnimation: (animationController, scrollController) {
        return CompositedTransformFollower(
          // key: ValueKey(key),
          showWhenUnlinked: widget.showWhenUnlinked,
          offset: targetInformation.offsetToTarget,
          link: _layerLink,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animationController,
              curve: widget.curve,
            ),
            child: Directionality(
              textDirection: widget.textDirection,
              // TODO: This is just a weird hack I found
              child: Builder(
                builder: (context) {
                  if (scrollController == null) {
                    return TooltipOverlay(
                      animatedTransitionBuilder:
                          widget.animatedTransitionBuilder,
                      child: Material(
                        type: MaterialType.transparency,
                        child: widget.content,
                      ),
                      padding: widget.padding,
                      margin: widget.margin,
                      targetSize: targetInformation.size,
                      target: targetInformation.target,
                      offset: widget.offset,
                      preferredDirection: widget.preferredDirection,
                      offsetToTarget: targetInformation.offsetToTarget,
                      borderRadius: widget.borderRadius,
                      tailBaseWidth: widget.tailBaseWidth,
                      tailLength: widget.tailLength,
                      backgroundColor:
                          widget.backgroundColor ?? theme.cardColor,
                      textDirection: widget.textDirection,
                      shadow: widget.shadow ?? defaultShadow,
                      elevation: widget.elevation,
                    );
                  }

                  // With a ScrollController, it needs offset and maxLength
                  return AnimatedBuilder(
                    animation: scrollController,
                    child: Material(
                      type: MaterialType.transparency,
                      child: widget.content,
                    ),
                    builder: (context, child) {
                      return TooltipOverlay(
                        extentBefore: scrollController.position.extentBefore,
                        extentAfter: scrollController.position.extentAfter,
                        animatedTransitionBuilder:
                            widget.animatedTransitionBuilder,
                        child: child!,
                        padding: widget.padding,
                        margin: widget.margin,
                        targetSize: targetInformation.size,
                        target: targetInformation.target,
                        offset: widget.offset,
                        preferredDirection: widget.preferredDirection,
                        offsetToTarget: targetInformation.offsetToTarget,
                        borderRadius: widget.borderRadius,
                        tailBaseWidth: widget.tailBaseWidth,
                        tailLength: widget.tailLength,
                        backgroundColor:
                            widget.backgroundColor ?? theme.cardColor,
                        textDirection: widget.textDirection,
                        shadow: widget.shadow ?? defaultShadow,
                        elevation: widget.elevation,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      skrim: GestureDetector(
        child: const SizedBox.expand(),
        behavior: HitTestBehavior.translucent,
        onTap: tooltipArea.hideTooltip,
      ),
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
    );

    tooltipArea.showTooltip();
  }
}

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/src/models/just_the_handler.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

// TODO: Add a controller
// TODO: Add a builder

class JustTheTooltip extends StatefulWithInterface {
  @override
  final Widget content;

  @override
  final Widget child;

  @override
  final bool isModal;

  @override
  final Duration waitDuration;

  @override
  final Duration showDuration;

  @override
  final Duration hoverShowDuration;

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

  @override
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

  // FIXME: I don't like this at all. We should just forward this so we don't
  // create two function signatures we have to upkeep.
  const JustTheTooltip({
    Key? key,
    required this.content,
    required this.child,
    this.isModal = false,
    this.waitDuration = const Duration(milliseconds: 0),
    this.showDuration = const Duration(milliseconds: 1500),
    this.hoverShowDuration = const Duration(milliseconds: 100),
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 75),
    this.preferredDirection = AxisDirection.down,
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
    // TODO:
    // this.minWidth,
    // this.minHeight,
    // this.maxWidth,
    // this.maxHeight,
  }) : super(key: key);

  @override
  _SimpleTooltipState createState() => _SimpleTooltipState();
}

class _SimpleTooltipState extends State<JustTheTooltip>
    with SingleTickerProviderStateMixin, JustTheHandler {
  OverlayEntry? entry;
  OverlayEntry? skrim;
  final _layerLink = LayerLink();

  /// This is a bit of suckery as I cannot find a good way to refresh the state
  /// of the overlay. Entry does not need this as it is inside a builder and not
  /// its own overlay state.
  var _key = 0;

  @override
  void initState() {
    animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    )..addStatusListener(handleStatusChanged);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant JustTheTooltip oldWidget) {
    Future<void>.delayed(Duration.zero).then((_) {
      setState(() {
        _key++;
        _key %= 2;
      });
      entry?.markNeedsBuild();
      skrim?.markNeedsBuild();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    entry?.remove();
    skrim?.remove();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Builder(
        builder: (context) {
          if (mouseIsConnected) {
            return MouseRegion(
              onEnter: (PointerEnterEvent event) => showTooltip(),
              onExit: (PointerExitEvent event) => hideTooltip(),
              child: widget.child,
            );
          } else {
            return GestureDetector(
              onTap: entry == null ? showTooltip : null,
              child: widget.child,
            );
          }
        },
      ),
    );
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    if (entry == null) {
      return;
    }

    super.handlePointerEvent(event);
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  ///
  /// Copied from Tooltip
  @override
  bool ensureTooltipVisible() {
    showTimer?.cancel();
    showTimer = null;
    if (entry != null) {
      // Stop trying to hide, if we were.
      hideTimer?.cancel();
      hideTimer = null;
      animationController.forward();
      return false; // Already visible.
    }
    createEntries();
    animationController.forward();
    return true;
  }

  @override
  void createEntries() {
    assert(entry == null);
    assert(skrim == null);

    final targetInformation = getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );

    entry = OverlayEntry(
      builder: (BuildContext context) {
        return CompositedTransformFollower(
          key: ValueKey(_key),
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
                  final scrollController = widget.scrollController;
                  final _child = Material(
                    type: MaterialType.transparency,
                    child: widget.content,
                  );

                  if (scrollController != null) {
                    return AnimatedBuilder(
                      animation: scrollController,
                      child: _child,
                      builder: (context, child) {
                        return TooltipOverlay(
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
                          scrollPosition: scrollController.position,
                        );
                      },
                    );
                  }

                  return TooltipOverlay(
                    animatedTransitionBuilder: widget.animatedTransitionBuilder,
                    child: _child,
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
                    backgroundColor: widget.backgroundColor ?? theme.cardColor,
                    textDirection: widget.textDirection,
                    shadow: widget.shadow ?? defaultShadow,
                    elevation: widget.elevation,
                    scrollPosition: null,
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (widget.isModal) {
      skrim = OverlayEntry(
        builder: (BuildContext context) {
          return GestureDetector(
            child: const SizedBox.expand(),
            behavior: HitTestBehavior.translucent,
            onTap: hideTooltip,
          );
        },
      );
    }

    final overlay = Overlay.of(context);

    if (overlay == null) {
      throw StateError('Cannot find the overlay for the context $context');
    }

    setState(() {
      if (widget.isModal) {
        overlay.insert(skrim!);
        overlay.insert(entry!, above: skrim);
      } else {
        overlay.insert(entry!);
      }
    });
  }

  @override
  void removeEntries() {
    hideTimer?.cancel();
    hideTimer = null;
    showTimer?.cancel();
    showTimer = null;

    setState(() {
      entry?.remove();
      entry = null;

      if (widget.isModal) {
        skrim?.remove();
        skrim = null;
      }
    });
  }
}

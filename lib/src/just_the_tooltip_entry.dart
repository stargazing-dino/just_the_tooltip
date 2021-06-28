import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/just_the_tooltip_area.dart';
import 'package:just_the_tooltip/src/models/just_the_handler.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

class JustTheTooltipEntry extends StatefulWithInterface {
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

  const JustTheTooltipEntry({
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
  }) : super(key: key);

  @override
  State<JustTheTooltipEntry> createState() => _JustTheTooltipEntryState();
}

// TODO: Do I need to deal with Deactivate?
class _JustTheTooltipEntryState extends State<JustTheTooltipEntry>
    with JustTheHandler, SingleTickerProviderStateMixin {
  Widget? get entry => JustTheTooltipArea.of(context).entry;
  Widget? get skrim => JustTheTooltipArea.of(context).skrim;
  Key get entryKey => Key('__entry_${widget.key}__');
  Key get scrimKey => Key('__skrim_${widget.key}__');
  final _layerLink = LayerLink();

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
  void deactivate() {
    if (entry != null) {
      hideTooltip(immediately: true);
    }
    showTimer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: This looks like the same builder over at just_the_tooltip.
    // Can we DRY?
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
              onLongPress: widget.isModal ? null : handleLongPress,
              onTap: widget.isModal
                  ? entry == null
                      ? showTooltip
                      : null
                  : null,
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
    final _entry = entry;
    if (_entry != null) {
      // Stop trying to hide, if we were.
      hideTimer?.cancel();
      hideTimer = null;

      if (_entry.key == entryKey) {
        animationController.forward();
        return false; // Already visible.

      } else {
        animationController.reset();
        return true; // Wrong tooltip was visible
      }
    }
    createEntries();
    animationController.forward();
    return true;
  }

  @override
  Future<void> createEntries() async {
    final tooltipArea = JustTheTooltipArea.of(context);
    final targetInformation = getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );

    tooltipArea.setState(
      () {
        tooltipArea.entry = CompositedTransformFollower(
          key: entryKey,
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
        if (widget.isModal) {
          tooltipArea.skrim = GestureDetector(
            key: scrimKey,
            child: const SizedBox.expand(),
            behavior: HitTestBehavior.translucent,
            onTap: hideTooltip,
          );
        }
      },
    );
  }

  @override
  void removeEntries() {
    hideTimer?.cancel();
    hideTimer = null;
    showTimer?.cancel();
    showTimer = null;

    final tooltipArea = JustTheTooltipArea.of(context);

    tooltipArea.setState(() {
      tooltipArea.entry = null;
      tooltipArea.skrim = null;
    });
  }
}

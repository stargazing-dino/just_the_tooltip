import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:just_the_tooltip/src/models/target_information.dart';
import 'package:just_the_tooltip/src/positioned_tooltip.dart';

part 'just_the_tooltip_entry.dart';

typedef ShowTooltip = Future<void> Function({
  bool immediately,

  /// If set to true, this will set the timer for the tooltip to close.
  bool autoClose,
});

typedef HideTooltip = Future<void> Function({bool immediately});

/// {@macro just_the_tooltip.overlay.constructor}
class JustTheTooltip extends StatefulWidget implements JustTheInterface {
  const JustTheTooltip({
    Key? key,
    required this.content,
    required this.child,
    this.onDismiss,
    this.onShow,
    this.controller,
    // TODO: With the new [triggerMode] field isModal's only function is to keep
    // the tooltip open. But in that case, it seems like we can create a new
    // more narrow field in favor.
    this.isModal = false,
    this.waitDuration,
    this.showDuration,
    this.triggerMode,
    this.barrierDismissible = true,
    this.barrierColor = Colors.transparent,
    this.barrierBuilder,
    this.enableFeedback,
    this.hoverShowDuration,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 75),
    this.preferredDirection = AxisDirection.down,
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    this.margin = const EdgeInsets.all(8.0),
    this.offset = 0.0,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.tailLength = 16.0,
    this.tailBaseWidth = 32.0,
    this.tailBuilder = JustTheInterface.defaultTailBuilder,
    this.animatedTransitionBuilder =
        JustTheInterface.defaultAnimatedTransitionBuilder,
    this.backgroundColor,
    this.textDirection = TextDirection.ltr,
    this.shadow,
    this.showWhenUnlinked = false,
    this.scrollController,
  }) : super(key: key);

  @override
  final JustTheController? controller;

  @override
  final Widget content;

  @override
  final Widget child;

  @override
  final VoidCallback? onDismiss;

  @override
  final VoidCallback? onShow;

  @override
  final bool isModal;

  @override
  final Duration? waitDuration;

  @override
  final Duration? showDuration;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final TooltipTriggerMode? triggerMode;

  @override
  final bool? enableFeedback;

  @override
  final Widget Function(BuildContext, VoidCallback)? barrierBuilder;

  // FIXME: This happens in the non-hover (i.e. isModal) case as well.
  @override
  final Duration? hoverShowDuration;

  @override
  final AxisDirection preferredDirection;

  @override
  final Duration fadeInDuration;

  @override
  final Duration fadeOutDuration;

  @override
  final Curve curve;

  @override
  final Curve reverseCurve;

  @override
  final EdgeInsetsGeometry margin;

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
  final TailBuilder tailBuilder;

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

  @override
  _JustTheTooltipOverlayState createState() => _JustTheTooltipOverlayState();
}

class _JustTheTooltipOverlayState extends _JustTheTooltipState<OverlayEntry> {
  @override
  OverlayEntry? entry;

  @override
  OverlayEntry? skrim;

  @override
  Future<bool> ensureTooltipVisible() async {
    cancelShowTimer();

    // Already visible.
    if (hasEntry) {
      cancelHideTimer();

      await _animationController.forward();
      return false;
    }

    _createNewEntries();
    await _animationController.forward();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(Overlay.of(context, debugRequiredFor: widget) != null);

    return super.build(context);
  }

  @override
  void _createNewEntries() {
    // The builder on these run twice on hot reload and then again from our
    // didUpdateWidget.
    final entryOverlay = OverlayEntry(builder: (context) {
      return _createEntry();
    });
    final skrimOverlay = OverlayEntry(builder: (context) => _createSkrim());

    final overlay = Overlay.of(context);

    if (overlay == null) {
      throw StateError('Cannot find the overlay for the context $context');
    }

    setState(
      () {
        // In the case of a modal, we enter a skrim overlay to catch taps
        if (widget.isModal) {
          entry = entryOverlay;
          skrim = skrimOverlay;

          overlay.insert(skrimOverlay);
          overlay.insert(entryOverlay, above: skrimOverlay);
        } else {
          entry = entryOverlay;

          overlay.insert(entryOverlay);
        }
      },
    );
  }

  @override
  void _removeEntries() {
    cancelHideTimer();
    cancelShowTimer();

    entry?.remove();

    if (widget.isModal) {
      skrim?.remove();
    }

    entry = null;

    if (widget.isModal) {
      skrim = null;
    }
  }

  // @override
  // void didUpdateWidget(covariant JustTheTooltip oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // This adds a post frame callback because otherwise the OverlayEntry
  //   // builder would run before the widget has a chance to update with the
  //   // newest config.
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     if (mounted) {
  //       entry?.markNeedsBuild();
  //       skrim?.markNeedsBuild();
  //     }
  //   });
  // }
}

/// This is almost a one to one mapping to [Tooltip]'s [_TooltipState] except
/// for the fact it is setup to handle two Tooltip cases. Abstract methods are
/// replaced with implementations that are specific to the tooltip type.
// TODO: This looks more idiomatic as a mixin.
abstract class _JustTheTooltipState<T> extends State<JustTheInterface>
    with SingleTickerProviderStateMixin {
  T? get entry;

  T? get skrim;

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  ///
  /// Copied from [Tooltip]
  Future<bool> ensureTooltipVisible();

  /// Creates both the tooltip entry and the tooltip entry. How they are
  /// inserted into the tree is dependent on tooltip strategy of using
  /// overlays or widgets.
  // ignore: unused_element
  void _createNewEntries();

  /// Removes the tooltip entry and tooltip entry.
  void _removeEntries();

  bool get hasEntry => entry != null;

  Key? get entryKey {
    final _key = widget.key;
    return _key == null ? null : ValueKey('__entry_${_key}__');
  }

  Key? get skrimKey {
    final _key = widget.key;
    return _key == null ? null : Key('__skrim_${_key}__');
  }

  // All of these are taken from default tooltip
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultHoverShowDuration = Duration(milliseconds: 100);
  static const Duration _defaultWaitDuration = Duration.zero;
  static const TooltipTriggerMode _defaultTriggerMode =
      TooltipTriggerMode.longPress;
  static const bool _defaultEnableFeedback = true;

  late final AnimationController _animationController;
  Timer? _hideTimer;
  Timer? _showTimer;
  late Duration showDuration;
  late Duration hoverShowDuration;
  late Duration waitDuration;
  late bool _mouseIsConnected = false;
  bool _pressActivated = false;
  late TooltipTriggerMode triggerMode;
  late bool enableFeedback;
  late bool barrierDismissible;
  late Color barrierColor;
  late Widget Function(BuildContext, VoidCallback)? barrierBuilder;

  // These properties are specific to just_the_tooltip
  // static const Curve _defaultAnimateCurve = Curves.linear;
  // static const Duration _defaultAnimateDuration = Duration(milliseconds: 1000);
  late JustTheController _controller;
  late bool _hasBindingListeners = false;
  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    // Handles mouse connection and global tap gestures.
    if (!widget.isModal) {
      // RendererBinding.instance!.mouseTracker.addListener seems to have a bug
      // if you move the mouse as the page is loading, the listener never gets
      // called. Set mouseConnected here as a work around
      _mouseIsConnected =
          RendererBinding.instance!.mouseTracker.mouseIsConnected;

      _addBindingListeners();
    }

    _animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

    _controller = widget.controller ?? JustTheController();
    _attachController(_controller);
  }

  /// This sucker just gives the controller the newest versions of the
  /// callbacks we have in this state.
  void _attachController(JustTheController controller) {
    controller.attach(
      showTooltip: _showTooltip,
      hideTooltip: _hideTooltip,
    );
  }

  @override
  void didUpdateWidget(covariant JustTheInterface oldWidget) {
    final _oldController = oldWidget.controller;
    final _newController = widget.controller;

    // If we did not have a controller before, we created one that must now be
    // disposed. The user must also have passed in a controller or else we
    // won't do anything.
    if (_oldController == null && _newController != null) {
      // The user provided a controller, let's dispose ours
      _controller.dispose();
      _controller = _newController;
    }

    // Update the functions on our controller
    if (_newController != null && _oldController != null) {
      if (_newController.value != _oldController.value) {
        _controller.value = _newController.value;
      }
    }

    _attachController(_controller);

    if (oldWidget.isModal != widget.isModal) {
      if (widget.isModal) {
        _removeBindingListeners();
      } else {
        _addBindingListeners();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  void _addBindingListeners() {
    if (_hasBindingListeners) return;

    _hasBindingListeners = true;

    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void _removeBindingListeners() {
    if (_hasBindingListeners) _hasBindingListeners = false;
    RendererBinding.instance?.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    GestureBinding.instance?.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
  }

  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }

    final mouseIsConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;

    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _hideTooltip(immediately: true);
    }
  }

  /// Hides the tooltip if it is currently visible. If [immediately] is true,
  /// the tooltip will be hidden immediately. Otherwise, the tooltip will be
  /// hidden after the current animation completes. In either case,
  /// this future will complete once the tooltip has been completely hidden.
  Future<void> _hideTooltip({bool immediately = false}) async {
    cancelShowTimer();

    final completer = Completer<void>();
    final future = completer.future;

    if (immediately) {
      widget.onDismiss?.call();

      if (mounted) {
        _controller.value = TooltipStatus.isHidden;
      }

      _removeEntries();
      completer.complete();
      return future;
    }

    if (_pressActivated) {
      _hideTimer ??= Timer(showDuration, () async {
        await _animationController.reverse();
        completer.complete();
      });
    } else {
      _hideTimer ??= Timer(
        hoverShowDuration,
        () async {
          await _animationController.reverse();
          completer.complete();
        },
      );
    }

    _pressActivated = false;

    return future;
  }

  Future<void> _showTooltip({
    bool immediately = false,

    /// This will usually be only true in the case of a controller requesting
    /// to show the tooltip as a regular pointer event will cause a pointer up
    /// event to be fired, which in turn will set a hide timer.
    bool autoClose = false,
  }) async {
    cancelHideTimer();

    final completer = Completer<void>();
    final future = completer.future.then((_) {
      widget.onShow?.call();

      if (mounted) {
        _controller.value = TooltipStatus.isShowing;

        if (autoClose) {
          _hideTooltip();
        }
      }
    });

    if (immediately) {
      // We add a postFrameCallback here because we need run *after* the global
      // _handlePointerEvent has been called (which happens after every tap
      // event).
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await ensureTooltipVisible();
        completer.complete();
      });

      return future;
    }

    _showTimer ??= Timer(waitDuration, () async {
      await ensureTooltipVisible();
      completer.complete();
    });

    return future;
  }

  void cancelShowTimer() {
    _showTimer?.cancel();
    _showTimer = null;
  }

  void cancelHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _handlePointerEvent(PointerEvent event) {
    if (!hasEntry) {
      return;
    }

    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _hideTooltip();
    } else if (event is PointerDownEvent) {
      _hideTooltip(immediately: true);
    }
  }

  @override
  void deactivate() {
    if (hasEntry) {
      _hideTooltip(immediately: true);
    }

    cancelShowTimer();
    super.deactivate();
  }

  @override
  void dispose() {
    if (_hasBindingListeners) {
      _removeBindingListeners();
    }

    _removeEntries();
    _animationController.dispose();

    /// If we've made our own controller because the user's is null, we need to
    /// dispose of it.
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Future<void> _handlePress() async {
    _pressActivated = true;
    final tooltipCreated = await ensureTooltipVisible();

    if (tooltipCreated && enableFeedback) {
      if (triggerMode == TooltipTriggerMode.longPress) {
        Feedback.forLongPress(context);
      } else {
        Feedback.forTap(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tooltipTheme = TooltipTheme.of(context);

    waitDuration = widget.waitDuration ??
        tooltipTheme.waitDuration ??
        _defaultWaitDuration;
    showDuration = widget.showDuration ??
        tooltipTheme.showDuration ??
        _defaultShowDuration;
    hoverShowDuration = widget.showDuration ??
        tooltipTheme.showDuration ??
        _defaultHoverShowDuration;
    triggerMode =
        widget.triggerMode ?? tooltipTheme.triggerMode ?? _defaultTriggerMode;
    enableFeedback = widget.enableFeedback ??
        tooltipTheme.enableFeedback ??
        _defaultEnableFeedback;
    barrierDismissible = widget.barrierDismissible;
    barrierColor = widget.barrierColor;
    barrierBuilder = widget.barrierBuilder;

    Widget result = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: widget.isModal
          ? null
          : (triggerMode == TooltipTriggerMode.longPress)
              ? _handlePress
              : null,
      onTap: widget.isModal
          ? _showTooltip
          : (triggerMode == TooltipTriggerMode.tap)
              ? _handlePress
              : null,
      excludeFromSemantics: true,
      child: widget.child,
    );

    if (_mouseIsConnected) {
      result = MouseRegion(
        onEnter: (PointerEnterEvent event) => _showTooltip(),
        onExit: (PointerExitEvent event) => _hideTooltip(),
        child: result,
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: result,
    );
  }

  Widget _createSkrim() {
    if (barrierBuilder != null) {
      return Container(
        key: skrimKey,
        child: barrierBuilder!(context, _hideTooltip),
      );
    }
    return GestureDetector(
      key: skrimKey,
      behavior: barrierDismissible
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      onTap: _hideTooltip,
      child: Container(color: barrierColor),
    );
  }

  Widget _createEntry() {
    // This is single use because after we've gotten the size and position,
    // if that child changes then this information will be stale.
    final targetInformation = _getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );

    return CompositedTransformFollower(
      showWhenUnlinked: widget.showWhenUnlinked,
      offset: targetInformation.offsetToTarget,
      link: _layerLink,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
          reverseCurve: widget.reverseCurve,
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
                    return PositionedTooltip(
                      // curve: _defaultAnimateCurve,
                      // duration: _defaultAnimateDuration,
                      animatedTransitionBuilder:
                          widget.animatedTransitionBuilder,
                      child: child!,
                      margin: widget.margin,
                      targetSize: targetInformation.size,
                      target: targetInformation.target,
                      offset: widget.offset,
                      preferredDirection: widget.preferredDirection,
                      offsetToTarget: targetInformation.offsetToTarget,
                      borderRadius: widget.borderRadius,
                      tailBaseWidth: widget.tailBaseWidth,
                      tailLength: widget.tailLength,
                      tailBuilder: widget.tailBuilder,
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

              return PositionedTooltip(
                // curve: _defaultAnimateCurve,
                // duration: _defaultAnimateDuration,
                animatedTransitionBuilder: widget.animatedTransitionBuilder,
                child: _child,
                margin: widget.margin,
                targetSize: targetInformation.size,
                target: targetInformation.target,
                offset: widget.offset,
                preferredDirection: widget.preferredDirection,
                offsetToTarget: targetInformation.offsetToTarget,
                borderRadius: widget.borderRadius,
                tailBaseWidth: widget.tailBaseWidth,
                tailLength: widget.tailLength,
                tailBuilder: widget.tailBuilder,
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
  }

  /// This assumes the caller itself is the target
  TargetInformation _getTargetInformation(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;

    if (box == null) {
      throw StateError(
        'Cannot find the box for the given object with context $context',
      );
    }

    final targetSize = box.getDryLayout(const BoxConstraints.tightForFinite());
    final target = box.localToGlobal(box.size.center(Offset.zero));
    // TODO: Instead of this, change the alignment on
    // [CompositedTransformFollower]. That way we can allow a user configurable
    // alignment on where the tooltip ends up.
    final offsetToTarget = Offset(
      -target.dx + box.size.width / 2,
      -target.dy + box.size.height / 2,
    );

    return TargetInformation(
      targetSize,
      target,
      offsetToTarget,
    );
  }
}

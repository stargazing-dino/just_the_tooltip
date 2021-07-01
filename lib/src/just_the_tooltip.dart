import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:just_the_tooltip/src/models/just_the_delegate.dart';
import 'package:just_the_tooltip/src/models/just_the_interface.dart';
import 'package:just_the_tooltip/src/models/target_information.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

// TODO: Add a controller
class JustTheTooltip extends JustTheInterface {
  JustTheTooltip({
    Key? key,
    required Widget content,
    required Widget child,
    bool isModal = false,
    Duration waitDuration = const Duration(milliseconds: 0),
    Duration showDuration = const Duration(milliseconds: 1500),
    Duration hoverShowDuration = const Duration(milliseconds: 100),
    Duration fadeInDuration = const Duration(milliseconds: 150),
    Duration fadeOutDuration = const Duration(milliseconds: 75),
    AxisDirection preferredDirection = AxisDirection.down,
    Curve curve = Curves.easeInOut,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    EdgeInsets margin = const EdgeInsets.all(8.0),
    double offset = 0.0,
    double elevation = 4.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(6)),
    double tailLength = 16.0,
    double tailBaseWidth = 32.0,
    AnimatedTransitionBuilder animatedTransitionBuilder =
        defaultAnimatedTransitionBuilder,
    Color? backgroundColor,
    TextDirection textDirection = TextDirection.ltr,
    Shadow? shadow,
    bool showWhenUnlinked = false,
    ScrollController? scrollController,
  }) : super(
          key: key,
          delegate: JustTheOverlayDelegate(),
          content: content,
          child: child,
          isModal: isModal,
          waitDuration: waitDuration,
          showDuration: showDuration,
          hoverShowDuration: hoverShowDuration,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          preferredDirection: preferredDirection,
          curve: curve,
          padding: padding,
          margin: margin,
          offset: offset,
          elevation: elevation,
          borderRadius: borderRadius,
          tailLength: tailLength,
          tailBaseWidth: tailBaseWidth,
          animatedTransitionBuilder: animatedTransitionBuilder,
          backgroundColor: backgroundColor,
          textDirection: textDirection,
          shadow: shadow,
          showWhenUnlinked: showWhenUnlinked,
          scrollController: scrollController,
        );

  JustTheTooltip.entry({
    Key? key,
    required Widget content,
    required Widget child,
    bool isModal = false,
    Duration waitDuration = const Duration(milliseconds: 0),
    Duration showDuration = const Duration(milliseconds: 1500),
    Duration hoverShowDuration = const Duration(milliseconds: 100),
    Duration fadeInDuration = const Duration(milliseconds: 150),
    Duration fadeOutDuration = const Duration(milliseconds: 75),
    AxisDirection preferredDirection = AxisDirection.down,
    Curve curve = Curves.easeInOut,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    EdgeInsets margin = const EdgeInsets.all(8.0),
    double offset = 0.0,
    double elevation = 4.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(6)),
    double tailLength = 16.0,
    double tailBaseWidth = 32.0,
    AnimatedTransitionBuilder animatedTransitionBuilder =
        defaultAnimatedTransitionBuilder,
    Color? backgroundColor,
    TextDirection textDirection = TextDirection.ltr,
    Shadow? shadow,
    bool showWhenUnlinked = false,
    ScrollController? scrollController,
  }) : super(
          key: key,
          delegate: JustTheEntryDelegate(key: key, context: null),
          content: content,
          child: child,
          isModal: isModal,
          waitDuration: waitDuration,
          showDuration: showDuration,
          hoverShowDuration: hoverShowDuration,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          preferredDirection: preferredDirection,
          curve: curve,
          padding: padding,
          margin: margin,
          offset: offset,
          elevation: elevation,
          borderRadius: borderRadius,
          tailLength: tailLength,
          tailBaseWidth: tailBaseWidth,
          animatedTransitionBuilder: animatedTransitionBuilder,
          backgroundColor: backgroundColor,
          textDirection: textDirection,
          shadow: shadow,
          showWhenUnlinked: showWhenUnlinked,
          scrollController: scrollController,
        );

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

  @override
  _JustTheTooltipState createState() => _JustTheTooltipState();
}

class _JustTheTooltipState extends State<JustTheTooltip>
    with SingleTickerProviderStateMixin {
  late JustTheDelegate delegate;
  final _layerLink = LayerLink();
  late final AnimationController _controller;
  Timer? _hideTimer;
  Timer? _showTimer;
  // TODO: These were late because they were intitialized from theme likely
  // late Duration showDuration;
  // late Duration hoverShowDuration;
  // late Duration waitDuration;
  late bool _mouseIsConnected = false;
  bool _longPressActivated = false;
  late bool hasListeners;

  /// This is a bit of suckery as I cannot find a good way to refresh the state
  /// of the overlay. Entry does not need this as it is inside a builder and not
  /// its own overlay state.
  var _key = 0;

  @override
  void initState() {
    final _delegate = widget.delegate;
    if (_delegate is JustTheEntryDelegate) {
      delegate = _delegate..context = context;
    } else if (_delegate is JustTheOverlayDelegate) {
      delegate = _delegate;
    }

    _controller = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

    if (!widget.isModal) {
      hasListeners = true;
      _addGestureListeners();
    } else {
      hasListeners = false;
    }

    super.initState();
  }

  // TODO: This thing needs to update when oldWidget.isDialog changes
  // everything needs to close too.
  @override
  void didUpdateWidget(covariant JustTheTooltip oldWidget) {
    if (oldWidget.isModal != widget.isModal) {
      if (widget.isModal) {
        _removeGestureListeners();
      } else {
        _addGestureListeners();
      }
    }

    if (oldWidget.scrollController != widget.scrollController) {
      Future<void>.delayed(Duration.zero).then((_) {
        removeEntries();
        _createNewEntries();
      });
    }

    final _delegate = delegate;

    if (_delegate is JustTheOverlayDelegate) {
      Future<void>.delayed(Duration.zero).then((_) {
        setState(() {
          _key++;
          _key %= 2;
        });

        _delegate.markNeedsBuild();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  void _addGestureListeners() {
    if (!hasListeners) hasListeners = true;
    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void _removeGestureListeners() {
    if (hasListeners) hasListeners = false;
    RendererBinding.instance?.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    GestureBinding.instance?.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
  }

  void _handleMouseTrackerChange() {
    if (!mounted) return;

    final isConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;

    if (isConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = isConnected;
      });
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _hideTooltip(immediately: true);
    }
  }

  void _hideTooltip({bool immediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;

    if (immediately) {
      removeEntries();
      return;
    }

    if (_longPressActivated) {
      _hideTimer ??= Timer(widget.showDuration, _controller.reverse);
    } else {
      _hideTimer ??= Timer(
        widget.hoverShowDuration,
        _controller.reverse,
      );
    }
    _longPressActivated = false;
  }

  void _showTooltip({bool immediately = false}) {
    _hideTimer?.cancel();
    _hideTimer = null;

    if (immediately) {
      ensureTooltipVisible();
      return;
    }

    _showTimer ??= Timer(widget.waitDuration, ensureTooltipVisible);
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  ///
  /// Copied from Tooltip
  bool ensureTooltipVisible() {
    final _delegate = delegate;

    _showTimer?.cancel();
    _showTimer = null;

    if (_delegate.hasEntry) {
      _hideTimer?.cancel();
      _hideTimer = null;

      if (_delegate is JustTheEntryDelegate) {
        // This checks if the current entry and the entry from the area are the
        // same
        if (_delegate.entry!.key == _delegate.entryKey) {
          _controller.forward();
          return false; // Already visible.

        } else {
          _controller.reset();
          return true; // Wrong tooltip was visible
        }
      } else {
        _controller.forward();
        return false; // Already visible.
      }
    }

    _createNewEntries();
    _controller.forward();
    return true;
  }

  void _createNewEntries() {
    final _delegate = delegate;

    final entry = _createEntry();
    final skrim = _createSkrim();

    if (_delegate is JustTheEntryDelegate) {
      final tooltipArea = JustTheTooltipArea.of(context);

      tooltipArea.setState(() {
        tooltipArea.skrim = skrim;
        tooltipArea.entry = entry;
      });
    } else if (_delegate is JustTheOverlayDelegate) {
      final entryOverlay = OverlayEntry(builder: (context) => entry);
      final skrimOverlay = OverlayEntry(builder: (context) => skrim);
      final overlay = Overlay.of(context);

      if (overlay == null) {
        throw StateError('Cannot find the overlay for the context $context');
      }

      setState(
        () {
          if (widget.isModal) {
            delegate = _delegate
              ..entry = entryOverlay
              ..skrim = skrimOverlay;

            overlay.insert(skrimOverlay);
            overlay.insert(entryOverlay, above: skrimOverlay);
          } else {
            delegate = _delegate..entry = entryOverlay;

            overlay.insert(entryOverlay);
          }
        },
      );
    }
  }

  void removeEntries() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer?.cancel();
    _showTimer = null;

    if (!mounted) return;

    final _delegate = delegate;

    if (_delegate is JustTheEntryDelegate) {
      final tooltipArea = JustTheTooltipArea.of(context);

      tooltipArea.setState(() {
        tooltipArea.entry = null;
        tooltipArea.skrim = null;
      });
    } else if (_delegate is JustTheOverlayDelegate) {
      _delegate.entry?.remove();

      setState(
        () {
          delegate = _delegate..entry = null;

          if (widget.isModal) {
            _delegate.skrim?.remove();
            delegate = _delegate
              ..entry = null
              ..skrim = null;
          }
        },
      );
    }
  }

  void _handlePointerEvent(PointerEvent event) {
    if (!delegate.hasEntry) return;

    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _hideTooltip();
    } else if (event is PointerDownEvent) {
      _hideTooltip(immediately: true);
    }
  }

  @override
  void deactivate() {
    if (delegate.hasEntry) {
      _hideTooltip(immediately: true);
    }

    _showTimer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    if (hasListeners) {
      _removeGestureListeners();
    }

    removeEntries();
    _controller.dispose();

    super.dispose();
  }

  void _handleLongPress() {
    _longPressActivated = true;
    final tooltipCreated = ensureTooltipVisible();

    if (tooltipCreated) {
      Feedback.forLongPress(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Builder(
        builder: (context) {
          if (_mouseIsConnected) {
            return MouseRegion(
              onEnter: (PointerEnterEvent event) => _showTooltip(),
              onExit: (PointerExitEvent event) => _hideTooltip(),
              child: widget.child,
            );
          } else {
            return GestureDetector(
              onLongPress: widget.isModal ? null : _handleLongPress,
              onTap: !delegate.hasEntry ? _showTooltip : null,
              child: widget.child,
            );
          }
        },
      ),
    );
  }

  Widget _createSkrim() {
    return GestureDetector(
      key: delegate.skrimKey,
      child: const SizedBox.expand(),
      behavior: HitTestBehavior.translucent,
      onTap: _hideTooltip,
    );
  }

  Widget _createEntry() {
    final targetInformation = _getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );
    final _delegate = delegate;
    Key? _widgetKey = delegate.entryKey;

    if (_delegate is JustTheOverlayDelegate) {
      _widgetKey = ValueKey(_key);
    }

    return CompositedTransformFollower(
      key: _widgetKey,
      showWhenUnlinked: widget.showWhenUnlinked,
      offset: targetInformation.offsetToTarget,
      link: _layerLink,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
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

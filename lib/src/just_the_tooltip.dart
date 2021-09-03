import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:just_the_tooltip/src/models/just_the_controller.dart';
import 'package:just_the_tooltip/src/models/just_the_delegate.dart';
import 'package:just_the_tooltip/src/models/just_the_interface.dart';
import 'package:just_the_tooltip/src/models/target_information.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

class JustTheTooltip extends JustTheInterface {
  JustTheTooltip({
    Key? key,
    required Widget content,
    required Widget child,
    JustTheController? controller,
    bool isModal = false,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? hoverShowDuration,
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
          controller: controller,
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
    JustTheController? controller,
    bool isModal = false,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? hoverShowDuration,
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
          controller: controller,
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
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultHoverShowDuration = Duration(milliseconds: 100);
  static const Duration _defaultWaitDuration = Duration.zero;

  late JustTheDelegate delegate;
  final _layerLink = LayerLink();
  late final AnimationController _animationController;
  late final JustTheController _controller;
  Timer? _hideTimer;
  Timer? _showTimer;
  ControllerAction? _previousAction;
  late Duration showDuration;
  late Duration hoverShowDuration;
  late Duration waitDuration;
  late bool _mouseIsConnected = false;
  bool _longPressActivated = false;
  late bool _hasBindingListeners = false;

  /// This is a bit of suckery as I cannot find a good way to refresh the state
  /// of the overlay. Entry does not need this as it is inside a builder and not
  /// its own overlay state.
  var _key = 0;

  @override
  void initState() {
    // Handles mouse connection and global tap gestures.
    if (!widget.isModal) {
      _addBindingListeners();
    }

    _animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

    _controller = widget.controller ?? JustTheController();
    _controller.addListener(_controllerListener);

    final _delegate = widget.delegate;
    if (_delegate is JustTheEntryDelegate) {
      // TODO: I don't want to do this. It looks anti-pattern.
      delegate = _delegate..context = context;
    } else if (_delegate is JustTheOverlayDelegate) {
      delegate = _delegate;
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final _delegate = delegate;
    if (_delegate is JustTheEntryDelegate) {
      _delegate.area =
          context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea>()!;
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant JustTheTooltip oldWidget) {
    final _oldController = oldWidget.controller;
    final _newController = widget.controller;

    // If we did not have a controller before, we created one that must now be
    // disposed. The user must also have passed in a controller or else we
    // won't do anything. If the user passes in a different instance of a
    // controller it is their responsibility to dispose of it.
    if (_oldController == null && _oldController != _newController) {
      // The user provided a controller, let's dispose ours
      _controller.removeListener(_controllerListener);
      _controller.dispose();
    }

    if (_newController != _oldController) {
      _controller = _newController ?? JustTheController();
      _controller.addListener(_controllerListener);
    }

    if (oldWidget.isModal != widget.isModal) {
      if (widget.isModal) {
        _removeBindingListeners();
      } else {
        _addBindingListeners();
      }
    }

    if (oldWidget.scrollController != widget.scrollController) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) {
          removeEntries();
          _createNewEntries();
        }
      });
    }

    final _delegate = delegate;

    if (_delegate is JustTheOverlayDelegate) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _key++;
            _key %= 2;
          });

          _delegate.markNeedsBuild();
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> _controllerListener() async {
    final controllerState = _controller.value;
    final completer = controllerState.completer;
    final immediately = controllerState.immediately;
    final previousAction = _previousAction;

    if (previousAction == null || previousAction != controllerState.action) {
      _previousAction = controllerState.action;

      switch (controllerState.action) {
        case ControllerAction.none:
          assert(completer == null);
          _controller.value = controllerState.copyWith(
            status: AnimationStatus.dismissed,
          );
          break;

        case ControllerAction.show:
          _controller.value = controllerState.copyWith(
            status: AnimationStatus.forward,
          );

          _showTooltip(immediately: immediately).then((_) {
            completer!.complete();
            _controller.value = controllerState.copyWith(
              action: ControllerAction.none,
              setCompleterToNull: true,
              status: AnimationStatus.completed,
            );
          });
          break;
        case ControllerAction.hide:
          _controller.value = controllerState.copyWith(
            status: AnimationStatus.reverse,
          );
          _hideTooltip(immediately: immediately).then((value) {
            completer!.complete();
            _controller.value = controllerState.copyWith(
              action: ControllerAction.none,
              setCompleterToNull: true,
              status: AnimationStatus.completed,
            );
          });
          break;
      }
    }
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

  Future<void> _hideTooltip({
    bool immediately = false,
    // FIXME: I don't want to have to pass this in.
    bool deactivated = false,
  }) async {
    final completer = Completer<void>();

    cancelShowTimer();

    if (immediately) {
      removeEntries(deactivated: deactivated);
      completer.complete();
      return completer.future;
    }

    if (_longPressActivated) {
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
    _longPressActivated = false;

    return completer.future;
  }

  Future<void> _showTooltip({bool immediately = false}) async {
    final completer = Completer<void>();

    cancelHideTimer();

    if (immediately) {
      await ensureTooltipVisible();
      completer.complete();
      return completer.future;
    }

    _showTimer ??= Timer(waitDuration, () async {
      await ensureTooltipVisible();
      completer.complete();
    });

    return completer.future;
  }

  void cancelShowTimer() {
    if (_controller.value.action != ControllerAction.none) {
      _controller.value = _controller.value.copyWith(
        action: ControllerAction.none,
        setCompleterToNull: true,
        status: AnimationStatus.dismissed,
      );
    }

    _showTimer?.cancel();
    _showTimer = null;
  }

  void cancelHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  ///
  /// Copied from [Tooltip]
  Future<bool> ensureTooltipVisible() async {
    cancelShowTimer();

    final _delegate = delegate;

    if (_delegate.hasEntry) {
      cancelHideTimer();

      if (_delegate is JustTheEntryDelegate) {
        // This checks if the current entry and the entry from the area are the
        // same
        if (_delegate.entry!.key == _delegate.entryKey) {
          await _animationController.forward();
          return false; // Already visible.

        } else {
          _animationController.reset();
          return true; // Wrong tooltip was visible
        }
      } else {
        await _animationController.forward();
        return false; // Already visible.
      }
    }

    _createNewEntries();
    await _animationController.forward();
    return true;
  }

  void _createNewEntries() {
    final _delegate = delegate;
    final entry = _createEntry();
    final skrim = _createSkrim();

    if (_delegate is JustTheEntryDelegate) {
      final tooltipArea = JustTheTooltipArea.of(context);

      // TODO: This looks anti-pattern.
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
          // In the case of a modal, we enter a skrim overlay to catch taps
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

  // Remove deactivated parameters
  void removeEntries({bool deactivated = false}) {
    cancelHideTimer();
    cancelShowTimer();

    final _delegate = delegate;

    if (_delegate is JustTheEntryDelegate) {
      // TODO: Following logic shuld all be inside _delegate no?
      if (!deactivated) {
        final tooltipArea = JustTheTooltipArea.of(context);

        tooltipArea.setState(() {
          tooltipArea.entry = null;
          tooltipArea.skrim = null;
        });
      } else {
        // TODO: Wat? This calls setState internally but with a mounted check.
        _delegate.area!.data.removeEntries();
      }
    } else if (_delegate is JustTheOverlayDelegate) {
      _delegate.entry?.remove();

      if (widget.isModal) {
        _delegate.skrim?.remove();
      }

      if (mounted && !deactivated) {
        setState(
          () {
            delegate = _delegate..entry = null;

            if (widget.isModal) {
              // TODO: I want copyWiths. This pattern is dangerous and doesn't
              // always work to notify of updates. (Here is an exception due to
              // setState.)
              delegate = _delegate
                ..entry = null
                ..skrim = null;
            }
          },
        );
      }
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

  // FIXME: This breaks stuff... So fix it
  // @override
  // void deactivate() {
  //   if (delegate.hasEntry) {
  //     _hideTooltip(immediately: true, deactivated: true);
  //   }

  //   _showTimer?.cancel();
  //   super.deactivate();
  // }

  @override
  void dispose() {
    if (_hasBindingListeners) {
      _removeBindingListeners();
    }

    removeEntries(deactivated: true);

    _animationController.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Future<void> _handleLongPress() async {
    _longPressActivated = true;
    final tooltipCreated = await ensureTooltipVisible();

    if (tooltipCreated) {
      Feedback.forLongPress(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (delegate is JustTheOverlayDelegate) {
      assert(Overlay.of(context, debugRequiredFor: widget) != null);
    }

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
              behavior: HitTestBehavior.opaque,
              onLongPress: widget.isModal ? null : _handleLongPress,
              onTap: widget.isModal ? _showTooltip : null,
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
          parent: _animationController,
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

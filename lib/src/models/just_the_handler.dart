import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/src/models/just_the_interface.dart';
import 'package:just_the_tooltip/src/models/target_information.dart';

abstract class StatefulWithInterface extends StatefulWidget
    with JustTheInterface {
  const StatefulWithInterface({Key? key}) : super(key: key);
}

/// To not repeate code, this handler manages all the stateful events around
/// timers, gestures and box coordination. This mixin is used in both
/// [just_the_tooltip] and [just_the_tooltip_entry].
mixin JustTheHandler<T extends StatefulWithInterface> on State<T> {
  late final AnimationController animationController;
  Timer? hideTimer;
  Timer? showTimer;
  // TODO: These were late because they were intitialized from theme likely
  // late Duration showDuration;
  // late Duration hoverShowDuration;
  // late Duration waitDuration;
  late bool mouseIsConnected = false;
  bool longPressActivated = false;

  @override
  void initState() {
    if (!widget.isModal) {
      addGestureListeners();
    }
    super.initState();
  }

  // TODO: This thing needs to update when oldWidget.isDialog changes
  // everything needs to close too.
  //
  @override
  void didUpdateWidget(covariant oldWidget) {
    if (oldWidget.isModal != widget.isModal) {
      if (widget.isModal) {
        removeGestureListeners();
      } else {
        addGestureListeners();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void addGestureListeners() {
    mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker
        .addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter.addGlobalRoute(handlePointerEvent);
  }

  void removeGestureListeners() {
    mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter
        .removeGlobalRoute(handlePointerEvent);
  }

  void handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      hideTooltip(immediately: true);
    }
  }

  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }

    final bool isConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (isConnected != mouseIsConnected) {
      setState(() {
        mouseIsConnected = isConnected;
      });
    }
  }

  @mustCallSuper
  void handlePointerEvent(PointerEvent event) {
    if (!widget.isModal) {
      if (event is PointerUpEvent || event is PointerCancelEvent) {
        hideTooltip();
      } else if (event is PointerDownEvent) {
        hideTooltip(immediately: true);
      }
    }
  }

  bool ensureTooltipVisible();

  void showTooltip({bool immediately = false}) {
    hideTimer?.cancel();
    hideTimer = null;

    if (immediately) {
      ensureTooltipVisible();
      return;
    }

    showTimer ??= Timer(widget.waitDuration, ensureTooltipVisible);
  }

  void hideTooltip({bool immediately = false}) {
    showTimer?.cancel();
    showTimer = null;

    if (immediately) {
      removeEntries();
      return;
    }

    if (longPressActivated) {
      hideTimer ??= Timer(
        widget.showDuration,
        () {
          if (mounted) {
            animationController.reverse();
          }
        },
      );
    } else {
      hideTimer ??= Timer(
        widget.hoverShowDuration,
        () {
          if (mounted) {
            animationController.reverse();
          }
        },
      );
    }
    longPressActivated = false;
  }

  void createEntries();

  void removeEntries();

  /// This assumes the caller itself is the target
  TargetInformation getTargetInformation(BuildContext context) {
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

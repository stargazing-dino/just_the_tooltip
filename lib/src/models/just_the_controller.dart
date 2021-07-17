import 'dart:async';

import 'package:flutter/material.dart';

enum ControllerAction { none, show, hide }

class ControllerState {
  final AnimationStatus status;

  final ControllerAction action;

  final Completer<void>? completer;

  const ControllerState({
    required this.status,
    required this.action,
    required this.completer,
  });

  factory ControllerState.empty() {
    return const ControllerState(
      status: AnimationStatus.dismissed,
      action: ControllerAction.none,
      completer: null,
    );
  }

  ControllerState copyWith({
    AnimationStatus? status,
    ControllerAction? action,
    Completer<void>? completer,
    bool setCompleterToNull = false,
  }) {
    return ControllerState(
      status: status ?? this.status,
      action: action ?? this.action,
      completer: setCompleterToNull ? null : completer ?? this.completer,
    );
  }
}

/// This controller provides basic controls over the Tooltip widget.
class JustTheController extends ValueNotifier<ControllerState> {
  JustTheController({ControllerState? value})
      : super(value ?? ControllerState.empty());

  bool get isShowing => value.status == AnimationStatus.completed;

  bool get isHidden => value.status == AnimationStatus.dismissed;

  bool get isAnimating =>
      value.status == AnimationStatus.forward ||
      value.status == AnimationStatus.reverse;

  /// Shows the tooltip. Completes when the tooltip is fully visible.
  Future<void> showTooltip() async {
    if (value.action == ControllerAction.show) return;

    final completer = Completer<void>();

    value = value.copyWith(
      action: ControllerAction.show,
      completer: completer,
    );

    return completer.future;
  }

  /// Hides the tooltip. Completes when the tooltip is fully hidden.
  Future<void> hideTooltip() async {
    if (value.action == ControllerAction.hide) return;

    final completer = Completer<void>();

    value = value.copyWith(
      action: ControllerAction.hide,
      completer: completer,
    );

    return completer.future;
  }
}

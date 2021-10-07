import 'dart:async';

import 'package:flutter/material.dart';

enum ControllerAction { none, show, hide }

class ControllerState {
  final AnimationStatus status;

  final ControllerAction action;

  final Completer<void>? completer;

  final bool immediately;

  const ControllerState({
    required this.status,
    required this.action,
    required this.completer,
    required this.immediately,
  });

  factory ControllerState.empty() {
    return const ControllerState(
      status: AnimationStatus.dismissed,
      action: ControllerAction.none,
      completer: null,
      immediately: false,
    );
  }

  ControllerState copyWith({
    AnimationStatus? status,
    ControllerAction? action,
    Completer<void>? completer,
    bool? immediately,

    /// You cannot set something to null using a copyWith constructor. `Freezed`
    /// gets around this limitation but I rather not depend on it for that small
    /// reason.
    bool setCompleterToNull = false,
  }) {
    return ControllerState(
      status: status ?? this.status,
      action: action ?? this.action,
      immediately: immediately ?? this.immediately,
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
  Future<void> showTooltip({bool immediately = false}) async {
    if (value.action == ControllerAction.show) return;

    final completer = Completer<void>();

    value = value.copyWith(
      action: ControllerAction.show,
      completer: completer,
      immediately: immediately,
    );

    return completer.future;
  }

  /// Hides the tooltip. Completes when the tooltip is fully hidden.
  Future<void> hideTooltip({bool immediately = false}) async {
    if (value.action == ControllerAction.hide) return;

    final completer = Completer<void>();

    value = value.copyWith(
      action: ControllerAction.hide,
      completer: completer,
      immediately: immediately,
    );

    return completer.future;
  }
}

class TooltipStatusNotifier extends ValueNotifier<bool> {
  TooltipStatusNotifier({bool? value}) : super(value ?? false);
}

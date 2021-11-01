import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

enum TooltipStatus { isShowing, isHidden }

/// This controller provides basic controls over the Tooltip widget.
/// It is just a shell class that is given functionality by the
/// [StatefulWidget]. This idea was copied from a [FocusNode] whose attach
/// method is called to give the focusNode the context and state of its parent.
class JustTheController extends ValueNotifier<TooltipStatus> {
  // TODO: This value is not refelected in the initial state of the tooltip
  JustTheController({TooltipStatus? value})
      : super(value ?? TooltipStatus.isHidden) {
    showTooltip = defaultShowTooltip;
    hideTooltip = defaultHideTooltip;
  }

  static Future<void> defaultShowTooltip({
    bool immediately = false,
    bool autoClose = false,
  }) {
    throw StateError('This controller has not been attached to a tooltip yet.');
  }

  static Future<void> defaultHideTooltip({bool immediately = false}) {
    throw StateError('This controller has not been attached to a tooltip yet.');
  }

  @mustCallSuper
  void attach({
    required ShowTooltip showTooltip,
    required HideTooltip hideTooltip,
  }) {
    this.showTooltip = showTooltip;
    this.hideTooltip = hideTooltip;
  }

  /// Shows the tooltip. Completes when the tooltip is fully visible.
  late ShowTooltip showTooltip;

  /// Hides the tooltip. Completes when the tooltip is fully hidden.
  late HideTooltip hideTooltip;
}

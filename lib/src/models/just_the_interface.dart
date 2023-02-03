import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/models/just_the_controller.dart';
import 'package:just_the_tooltip/src/positioned_tooltip.dart';

typedef ContentBuilder = Widget Function(BuildContext context, Widget content);

/// {@template just_the_tooltip.overlay.constructor}
/// A widget to display a tooltip over target widget. The tooltip can be
/// displayed on any axis of the widget and fallback to the opposite axis if
/// the tooltip does cannot fit its content. The tooltip can will be dismissed
/// by waiting a specified time or again tapping on the target widger or
/// anywhere on the screen.
///
/// Keep in mind there are different behaviours for the tooltip when [isModal]
/// is set to true. The effect is to mimic the behavior of a traditional modal
/// that is only closed by tapping on the target widget or outside the screen.
/// {@endtemplate}
abstract class JustTheInterface extends StatefulWidget {
  const JustTheInterface({Key? key}) : super(key: key);

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

  /// Draws a linear closed triangle path for the tail.
  static Path defaultTailBuilder(Offset tip, Offset point2, Offset point3) {
    return Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(point2.dx, point2.dy)
      ..lineTo(point3.dx, point3.dy)
      ..close();
  }

  /// Draws a bezier closed triangle path for the tail.
  static Path defaultBezierTailBuilder(
    Offset tip,
    Offset point2,
    Offset point3,
  ) {
    final offsetBetween = Offset(
      lerpDouble(point2.dx, point3.dx, 0.5)!,
      lerpDouble(point2.dy, point3.dy, 0.5)!,
    );

    return Path()
      ..moveTo(tip.dx, tip.dy)
      ..quadraticBezierTo(
        offsetBetween.dx,
        offsetBetween.dy,
        point2.dx,
        point2.dy,
      )
      ..lineTo(point3.dx, point3.dy)
      ..quadraticBezierTo(
        offsetBetween.dx,
        offsetBetween.dy,
        tip.dx,
        tip.dy,
      )
      ..close();
  }

  /// Imperitive controller for handling the state the interface is in. If one
  /// is not provided a controller will be made.
  JustTheController? get controller;

  /// The content of the tooltip. Content must be collapsed so it does not
  /// exceed it's constraints. The content's intrinsic `size` is used to first
  /// to get the quadrant of the tooltip. It is then layed out with those
  /// quadrant constraints limiting its size.
  ///
  /// If no [scrollController] is provided, the content will be constrained by
  /// the immediate viewport quadrant it is placed in. Note that
  /// [preferredDirection] is not the final [AxisDirection] but may be placed
  /// opposite.
  ///
  /// If a [scrollController] is provided, the layout algorithm will add
  /// `extentBefore` or `extentAfter` to the constraints calculations.
  Widget get content;

  /// The child widget the tooltip will hover over. This widget does not need
  /// any event handling logic as it will be wrapped necessary handlers.
  ///
  /// This widget will trigger the tooltip either through an `onTap` in the
  /// `isModal` is true case or through a mouse enter event with a `MouseRegion`
  /// in the `isModal` is false case.
  Widget get child;

  /// Called when the tooltip is dismissed either by waiting the specified
  /// [duration] or by tapping on the scrim.
  VoidCallback? get onDismiss;

  /// Called when the tooltip is shown.
  VoidCallback? get onShow;

  /// If true, once the tooltip is opened, it will not close after a set
  /// duration. It will instead instead stay on the screen until either the
  /// `scrim` is clicked or it is forcibly closed
  bool get isModal;

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  ///
  /// Copied from [Tooltip]
  Duration? get waitDuration;

  /// The length of time that the tooltip will be shown after a long press
  /// is released or mouse pointer exits the widget.
  ///
  /// Defaults to 1.5 seconds for long press released or 0.1 seconds for mouse
  /// pointer exits the widget.
  ///
  /// Copied from [Tooltip]
  Duration? get showDuration;

  /// The [TooltipTriggerMode] that will show the tooltip.
  ///
  /// If this property is null, then [TooltipThemeData.triggerMode] is used.
  /// If [TooltipThemeData.triggerMode] is also null, the default mode is
  /// [TooltipTriggerMode.longPress].
  TooltipTriggerMode? get triggerMode;

  /// The option to hide the tooltip.
  ///
  /// If [barrierDismissible] is true, then tooltip might be hidden
  /// by clicking outside tooltip. True is default.
  /// If [barrierDismissible] is false, it can be hidden only manually
  /// by using [controller.hideTooltip].
  bool get barrierDismissible;

  /// A widget to be displayed between the tooltip and app's content.
  ///
  /// Defaults to [Colors.transparent].
  ///
  /// If [barrierBuilder] is non-null, barrier color will be ignored.
  Color get barrierColor;

  /// A widget to be displayed between the tooltip and app's content.
  ///
  /// The barrier builder can call the provided void callback to dismiss the
  /// tooltip.
  ///
  /// This is most often a tapable container with a semi-opaque color:
  ///
  /// ```
  ///   barrierBuilder: (context, dismissTooltip) {
  ///     return GestureDetector(
  ///       onTap: dismissTooltip,
  ///       child: Container(color: Colors.black38), // black38 has 38% opacity
  ///     );
  ///   },
  /// ```
  ///
  /// If barrier builder is null, a default barrier is built according to
  /// [barrierColor] and [barrierDismissible].
  Widget Function(BuildContext, Animation<double>, VoidCallback)?
      get barrierBuilder;

  /// Whether the tooltip should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback], for providing platform-specific feedback to certain actions.
  bool? get enableFeedback;

  // FIXME: This happens in the non-hover (i.e. isModal) case as well.
  /// The amount of time before the tooltip is shown in the hover state.
  Duration? get hoverShowDuration;

  /// An axis that you want to place the tooltip along. Note that if there
  /// is not enough space on that axis, the layout algorithm might decide to
  /// place it along the opposite axis. If not enough space exists on both
  /// sides, a constraints error will be thrown.
  AxisDirection get preferredDirection;

  /// The amount of time the tooltip takes to fade into view after a hover in or
  /// tap event respective of `isModal`.
  Duration get fadeInDuration;

  /// The amount of time the tooltip takes to fade out of view after a hover out
  /// or a tapping of a skrim respective of `isModal`.
  Duration get fadeOutDuration;

  /// The curve of the fade animation.
  Curve get curve;

  /// The reverse curve of the fade animation.
  Curve get reverseCurve;

  /// The margin the tooltip keeps around edges of its box constraints.
  EdgeInsetsGeometry get margin;

  /// The vertical or horizontal offset from the base of the [content] to the
  /// tip of the tail of the tooltip.
  double get offset;

  /// The elevation of the tooltip. This is not directly used in any
  /// material elevation property but rather translated to a canvas shadow.
  double get elevation;

  /// The border radius of the tooltip
  BorderRadiusGeometry get borderRadius;

  /// The length of the tail or the amount of space from the tooltip
  /// target + [offset] to the nearest edge of the tooltip.
  double get tailLength;

  /// The base length of the tooltip on the edge of the tooltip
  double get tailBaseWidth;

  /// Defines how the path of the tail is built. The two options currently
  /// provided are the static methods [defaultTailBuilder] and
  /// [defaultBezierTailBuilder], but you may just as easily provide your own.
  TailBuilder get tailBuilder;

  /// A customizable builder that can be used to define the transition the
  /// tooltip uses when animating into view
  AnimatedTransitionBuilder get animatedTransitionBuilder;

  // TODO: The tail should be able to be colored a different color but should
  // default to this color.
  /// The background color of the tooltip. This includes the tail.
  Color? get backgroundColor;

  /// The text direction that will `resolve` the [content] of the tooltip.
  TextDirection get textDirection;

  /// A custom shadow that can be used to add behind the tooltip
  Shadow? get shadow;

  /// When the target of the tooltip, the [child], goes out of the viewport
  /// whether the content dissapears along with it is determined by this
  /// property.
  bool get showWhenUnlinked;

  /// If passed, this will no longer bound the tooltip to the immediate
  /// viewport but to the space allotted by the ScrollView it is in. For
  /// example, if the tooltip happens to go beyond its quadrant but there is
  /// scroll space beneath it the bounds will accomadate it.
  ScrollController? get scrollController;
}

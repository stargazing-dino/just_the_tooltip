import 'package:flutter/material.dart';

abstract class JustTheInterface {
  /// The content of the tooltip. Content must be collapsed so it does not
  /// exceed it's constraints. The content's intrinsics `size` is used to first
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
  Duration get waitDuration;

  /// The length of time that the tooltip will be shown after a long press
  /// is released or mouse pointer exits the widget.
  ///
  /// Defaults to 1.5 seconds for long press released or 0.1 seconds for mouse
  /// pointer exits the widget.
  ///
  /// Copied from [Tooltip]
  Duration get showDuration;

  /// The amount of time before the tooltip is shown in the hover state.
  // FIXME: This happens in the non-hover (i.e. isModal) case as well.
  Duration get hoverShowDuration;

  /// An axis that you hope you to place the tooltip along. Note that if there
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

  /// The padding around the content of the tooltip.
  EdgeInsets get padding;

  /// The margin the tooltip keeps around edges of its box constraints.
  EdgeInsets get margin;

  /// The vertical or horizontal offset from the base of the [content] to the
  /// tip of the tail of the tooltip.
  double get offset;

  double get elevation;

  /// The border radius of the tooltip
  BorderRadiusGeometry get borderRadius;

  /// The length of the tail or the amount of space from the tooltip
  /// target + [offset] to the nearest edge of the tooltip.
  double get tailLength;

  /// The base length of the tooltip on the edge of the tooltip
  double get tailBaseWidth;

  /// A customizable builder that can be used to define the transition the
  /// tooltip uses when animating into view
  AnimatedTransitionBuilder get animatedTransitionBuilder;

  /// The background color of the tooltip. This includes the tail.
  // TODO: The tail should be able to be colored a different color but should
  // default to this color.
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

abstract class JustTheStatefulInterface extends StatefulWidget
    with JustTheInterface {
  const JustTheStatefulInterface({Key? key}) : super(key: key);
}

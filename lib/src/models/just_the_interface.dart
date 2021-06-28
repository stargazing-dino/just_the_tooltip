import 'package:flutter/material.dart';

abstract class JustTheInterface {
  Widget get content;

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

  Duration get hoverShowDuration;

  AxisDirection get preferredDirection;

  Duration get fadeInDuration;

  Duration get fadeOutDuration;

  Curve get curve;

  EdgeInsets get padding;

  EdgeInsets get margin;

  double get offset;

  double get elevation;

  BorderRadiusGeometry get borderRadius;

  double get tailLength;

  double get tailBaseWidth;

  /// These directly affect the constraints of the tooltip
  // BoxConstraints constraints;

  AnimatedTransitionBuilder get animatedTransitionBuilder;

  Color? get backgroundColor;

  TextDirection get textDirection;

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

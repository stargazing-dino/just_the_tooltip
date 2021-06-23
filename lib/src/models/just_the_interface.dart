import 'package:flutter/material.dart';

abstract class JustTheInterface {
  Widget get content;

  Widget get child;

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

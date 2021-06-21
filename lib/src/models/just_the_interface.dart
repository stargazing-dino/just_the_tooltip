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

  bool get showWhenUnlinked;
}

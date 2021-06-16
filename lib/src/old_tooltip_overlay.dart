// library simple_tooltip;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:just_the_tooltip/just_the_tooltip.dart';
// import 'package:just_the_tooltip/src/horizontal_geometry.dart';
// import 'package:just_the_tooltip/src/vertical_geometry.dart';

// class TooltipOverlay extends StatefulWidget {
//   final Widget content;

//   final EdgeInsets padding;

//   final EdgeInsets margin;

//   final Animation<double> animation;

//   final Size boxSize;

//   final Offset target;

//   final double offset;

//   final AxisDirection preferredDirection;

//   final LayerLink link;

//   final Offset offsetToTarget;

//   final double elevation;

//   final BorderRadiusGeometry borderRadius;

//   final double tailBaseWidth;

//   final double tailLength;

//   final AnimatedTransitionBuilder animatedTransitionBuilder;

//   final Color? color;

//   const TooltipOverlay({
//     Key? key,
//     required this.content,
//     required this.padding,
//     required this.margin,
//     required this.animation,
//     required this.boxSize,
//     required this.target,
//     required this.offset,
//     required this.preferredDirection,
//     required this.link,
//     required this.offsetToTarget,
//     required this.elevation,
//     required this.borderRadius,
//     required this.tailBaseWidth,
//     required this.tailLength,
//     required this.animatedTransitionBuilder,
//     required this.color,
//   }) : super(key: key);

//   @override
//   State<TooltipOverlay> createState() => _TooltipOverlayState();
// }

// class _TooltipOverlayState extends State<TooltipOverlay> {
//   final _key = GlobalKey();
//   Size? childSize;
//   var isOffStage = true;

//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((value) {
//       _setRenderBox();
//       setState(() {
//         isOffStage = false;
//       });
//     });

//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     _setRenderBox();
//     super.didChangeDependencies();
//   }

//   void _setRenderBox() {
//     final _size = _key.currentContext?.size;

//     if (_size != null) {
//       setState(() {
//         childSize = _size;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final child = Material(
//       key: _key,
//       type: MaterialType.transparency,
//       child: Container(
//         padding: widget.padding,
//         child: widget.content,
//         margin: widget.margin,
//         decoration: ShapeDecoration(
//           color: widget.color ?? Theme.of(context).cardColor,
//           shadows: kElevationToShadow[widget.elevation],
//           shape: MessageShape(
//             margin: widget.margin,
//             offset: widget.offset,
//             target: widget.target,
//             borderRadius: widget.borderRadius,
//             tailBaseWidth: widget.tailBaseWidth,
//             tailLength: widget.tailLength,
//           ),
//         ),
//       ),
//     );

//     print('building');
//     return Offstage(
//       offstage: isOffStage,
//       child: AnimatedBuilder(
//         animation: widget.animation,
//         builder: (context, child) {
//           return widget.animatedTransitionBuilder(
//             context,
//             widget.animation,
//             child,
//           );
//         },
//         child: CompositedTransformFollower(
//           link: widget.link,
//           showWhenUnlinked: false,
//           // TODO: expose following anchor and target anchor
//           offset: widget.offsetToTarget,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final _childSize = childSize;

//               final _constraints = getConstraintsForChild(
//                 constraints,
//                 _childSize,
//               );
//               final position = getPositionForChild(
//                 constraints.biggest,
//                 _childSize,
//               );
//               print(position);

//               Align

//               return Positioned(
//                 top: position.dy,
//                 left: position.dx,
//                 child: ConstrainedBox(
//                   constraints: _constraints,
//                   child: child,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   BoxConstraints getConstraintsForChild(
//       BoxConstraints constraints, Size childSize) {
//     var loosenedConstraints = constraints.loosen();

//     final offsetAndTail = widget.tailLength + widget.offset;
//     final axisDirection = _getFinalAxisDirection(
//       constraints.biggest,
//       childSize,
//     );

//     switch (axisDirection) {
//       case AxisDirection.down:
//         final maxHeight =
//             loosenedConstraints.maxHeight - (widget.target.dy + offsetAndTail);
//         loosenedConstraints = loosenedConstraints.copyWith(
//           maxHeight: maxHeight,
//         );
//         break;
//       case AxisDirection.up:
//         final maxHeight =
//             loosenedConstraints.maxHeight - (widget.target.dy + offsetAndTail);
//         loosenedConstraints = loosenedConstraints.copyWith(
//           maxHeight: maxHeight,
//         );
//         break;
//       case AxisDirection.left:
//         final maxWidth =
//             loosenedConstraints.maxWidth - (widget.target.dx + offsetAndTail);
//         loosenedConstraints = loosenedConstraints.copyWith(
//           maxWidth: maxWidth,
//         );
//         break;
//       case AxisDirection.right:
//         final maxWidth =
//             loosenedConstraints.maxWidth - (widget.target.dx + offsetAndTail);
//         loosenedConstraints = loosenedConstraints.copyWith(
//           maxWidth: maxWidth,
//         );
//         break;
//     }

//     return loosenedConstraints;
//   }

//   double get sumOffset => widget.offset + widget.tailLength;

//   Offset getPositionForChild(Size size, Size childSize) {
//     switch (widget.preferredDirection) {
//       case AxisDirection.down:
//       case AxisDirection.up:
//         return verticalPositionDependentBox(
//           size: size,
//           childSize: childSize,
//           target: widget.target,
//           verticalOffset: sumOffset,
//           preferBelow: widget.preferredDirection == AxisDirection.down,
//           margin: 0.0,
//         );
//       case AxisDirection.left:
//       case AxisDirection.right:
//         return horizontalPositionDependentBox(
//           size: size,
//           childSize: childSize,
//           target: widget.target,
//           horizontalOffset: sumOffset,
//           preferLeft: widget.preferredDirection == AxisDirection.left,
//           margin: 0.0,
//           // margin: margin.horizontal,
//         );
//     }
//   }

//   AxisDirection _getFinalAxisDirection(Size size, Size childSize) {
//     switch (widget.preferredDirection) {
//       case AxisDirection.down:
//       case AxisDirection.up:
//         return isBelow(
//           size: size,
//           childSize: childSize,
//           target: widget.target,
//           verticalOffset: sumOffset,
//           preferBelow: widget.preferredDirection == AxisDirection.down,
//           margin: 0.0,
//           // margin: margin.vertical,
//         )
//             ? AxisDirection.down
//             : AxisDirection.up;
//       case AxisDirection.left:
//       case AxisDirection.right:
//         return isLeft(
//           size: size,
//           childSize: childSize,
//           target: widget.target,
//           horizontalOffset: sumOffset,
//           preferLeft: widget.preferredDirection == AxisDirection.left,
//           margin: 0.0,
//           // margin: margin.horizontal,
//         )
//             ? AxisDirection.left
//             : AxisDirection.right;
//     }
//   }
// }

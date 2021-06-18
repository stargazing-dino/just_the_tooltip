import 'package:flutter/material.dart';

class PositionDependentBox {
  final Offset offset;

  final AxisDirection axisDirection;

  const PositionDependentBox({
    required this.offset,
    required this.axisDirection,
  });

  PositionDependentBox copyWith({
    Offset? offset,
    AxisDirection? axisDirection,
  }) {
    return PositionDependentBox(
      offset: offset ?? this.offset,
      axisDirection: axisDirection ?? this.axisDirection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionDependentBox &&
        other.offset == offset &&
        other.axisDirection == axisDirection;
  }

  @override
  int get hashCode => offset.hashCode ^ axisDirection.hashCode;

  @override
  String toString() {
    return 'PositionDependentBox(  $offset,  $axisDirection  )';
  }
}

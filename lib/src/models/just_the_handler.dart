import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/models/target_information.dart';

// mixin SingleTickerProviderStateMixin<T extends StatefulWidget> on State<T>
mixin JustTheHandler<T extends StatefulWidget> on State<T> {
  Future<void> hideTooltip({bool immediately = false});

  Future<void> showTooltip({bool immediately = false});
}

// This assumes the caller itself is the target
TargetInformation getTargetInformation(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;

  if (box == null) {
    throw StateError(
      'Cannot find the box for the given object with context $context',
    );
  }

  final targetSize = box.getDryLayout(const BoxConstraints.tightForFinite());
  final target = box.localToGlobal(box.size.center(Offset.zero));
  final offsetToTarget = Offset(
    -target.dx + box.size.width / 2,
    -target.dy + box.size.height / 2,
  );

  return TargetInformation(
    targetSize,
    target,
    offsetToTarget,
  );
}

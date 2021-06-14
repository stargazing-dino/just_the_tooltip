import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Can I do layout here?
class TooltipOverlay extends SingleChildRenderObjectWidget {
  const TooltipOverlay({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderTooltipOverlay();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTooltipOverlay renderObject,
  ) {
    return;
  }
}

class _RenderTooltipOverlay extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    throw UnimplementedError();
  }
}

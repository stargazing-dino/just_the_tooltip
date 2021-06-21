import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/models/just_the_handler.dart';

/// The interface for a tooltip builder. This is useful when the user wants to
/// insert the tooltip into a stack rather than an overlay
typedef TooltipBuilder = Widget Function(
  BuildContext context,
  Widget? tooltip,

  /// This widget should be placed behind the tooltip. When tapped, it will
  /// collapse the tooltip.
  Widget? scrim,
);

class InheritedTooltipArea extends InheritedWidget {
  final _JustTheTooltipAreaState data;

  const InheritedTooltipArea({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class JustTheTooltipArea extends StatefulWidget {
  final TooltipBuilder builder;

  const JustTheTooltipArea({Key? key, required this.builder}) : super(key: key);

  /// Used to retrieve the scope of the tooltip. This scope is responsible for
  /// managing the children `JustTheTooltip`s
  static _JustTheTooltipAreaState of(BuildContext context) {
    var scope =
        context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea>();
    assert(
      () {
        if (scope == null) {
          throw FlutterError(
            'JustTheTooltipArea operation requested with a context that does not '
            'include a JustTheTooltipArea.\n Make sure you wrapped your'
            'JustTheTooltip children inside a JustTheTooltipArea',
          );
        }
        return true;
      }(),
    );
    return scope!.data;
  }

  static _JustTheTooltipAreaState? maybeOf(BuildContext context) {
    var scope =
        context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea>();

    return scope?.data;
  }

  @override
  State<JustTheTooltipArea> createState() => _JustTheTooltipAreaState();
}

class _JustTheTooltipAreaState extends State<JustTheTooltipArea>
    with SingleTickerProviderStateMixin, JustTheHandler {
  late final AnimationController _animationController;
  Widget? _entry;
  Widget? _skrim;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTooltipArea(
      data: this,
      child: widget.builder(
        context,
        _entry,
        _skrim,
      ),
    );
  }

  @override
  Future<void> hideTooltip({bool immediately = false}) async {
    if (!immediately) {
      await _animationController.reverse();
    }

    setState(() {
      _entry = null;
      _skrim = null;
    });
  }

  // This is to be called by children.
  @override
  Future<void> showTooltip({
    // TODO: This is somehow required? But i can't break the contract
    RenderBox? targetBox,
    bool immediately = false,
  }) async {
    assert(_entry != null);
    assert(_skrim != null);

    await _animationController.forward();
  }

  void buildChild({
    required Widget Function(AnimationController animationController)
        withAnimation,
    required Widget skrim,
    required Duration duration,
    required Duration reverseDuration,
  }) {
    _animationController.duration = duration;
    _animationController.reverseDuration = reverseDuration;

    setState(() {
      _entry = withAnimation(_animationController);
      _skrim = skrim;
    });
  }
}

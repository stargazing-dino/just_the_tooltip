import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/src/just_the_tooltip_area.dart';
import 'package:just_the_tooltip/src/models/just_the_handler.dart';
import 'package:just_the_tooltip/src/models/just_the_interface.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

// TODO: Add a controller
// TODO: Add a builder

class JustTheTooltip extends StatefulWidget implements JustTheInterface {
  @override
  final Widget content;

  @override
  final Widget child;

  @override
  final AxisDirection preferredDirection;

  @override
  final Duration fadeInDuration;

  @override
  final Duration fadeOutDuration;

  @override
  final Curve curve;

  @override
  final EdgeInsets padding;

  @override
  final EdgeInsets margin;

  @override
  final double offset;

  @override
  final double elevation;

  @override
  final BorderRadiusGeometry borderRadius;

  @override
  final double tailLength;

  @override
  final double tailBaseWidth;

  /// These directly affect the constraints of the tooltip
  // BoxConstraints constraints;

  @override
  final AnimatedTransitionBuilder animatedTransitionBuilder;

  @override
  final Color? backgroundColor;

  @override
  final TextDirection textDirection;

  @override
  final Shadow? shadow;

  @override
  final bool showWhenUnlinked;

  @override
  final ScrollController? scrollController;

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

  // FIXME: I don't like this at all. We should just forward this so we don't
  // create two function signatures we have to upkeep.
  const JustTheTooltip({
    Key? key,
    required this.content,
    required this.child,
    this.preferredDirection = AxisDirection.down,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 0),
    this.curve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(8.0),
    this.offset = 0.0,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.tailLength = 16.0,
    this.tailBaseWidth = 32.0,
    this.animatedTransitionBuilder = defaultAnimatedTransitionBuilder,
    this.backgroundColor,
    this.textDirection = TextDirection.ltr,
    this.shadow,
    this.showWhenUnlinked = false,
    this.scrollController,
    // TODO:
    // this.minWidth,
    // this.minHeight,
    // this.maxWidth,
    // this.maxHeight,
  }) : super(key: key);

  @override
  _SimpleTooltipState createState() => _SimpleTooltipState();
}

class _SimpleTooltipState extends State<JustTheTooltip>
    with SingleTickerProviderStateMixin, JustTheHandler {
  final _layerLink = LayerLink();
  late final AnimationController _animationController;
  OverlayEntry? _entry;
  OverlayEntry? _skrim;

  var _key = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant JustTheTooltip oldWidget) {
    Future<void>.delayed(Duration.zero).then((_) {
      setState(() {
        _key++;
        _key %= 2;
      });
      _entry?.markNeedsBuild();
      _skrim?.markNeedsBuild();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _entry?.remove();
    _skrim?.remove();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _entry == null ? showTooltip : null,
        child: widget.child,
      ),
    );
  }

  void debugCheck() {
    assert(
      JustTheTooltipArea.maybeOf(context) == null,
      'Did you mean to create a JustTheTooltipEntry? JustTheTooltip must not '
      'wrapped in a JustTheTooltipArea. If you\'re use case is valid, please '
      'file an issue on the repo.',
    );
  }

  @override
  bool get tooltipVisible => _entry != null;

  @override
  Future<void> hideTooltip({bool immediately = false}) async {
    debugCheck();
    if (!immediately) {
      await _animationController.reverse();
    }

    _entry?.remove();
    _skrim?.remove();

    setState(() {
      _entry = null;
      _skrim = null;
    });
  }

  @override
  Future<void> showTooltip({bool immediately = false}) async {
    debugCheck();
    createEntries();

    await _animationController.forward();
  }

  void createEntries({RenderBox? targetBox}) {
    assert(targetBox == null);
    assert(_entry == null);
    assert(_skrim == null);

    final targetInformation = getTargetInformation(context);
    final theme = Theme.of(context);
    final defaultShadow = Shadow(
      offset: Offset.zero,
      blurRadius: 0.0,
      color: theme.shadowColor,
    );

    _entry = OverlayEntry(
      builder: (BuildContext context) {
        return CompositedTransformFollower(
          key: ValueKey(_key),
          showWhenUnlinked: widget.showWhenUnlinked,
          offset: targetInformation.offsetToTarget,
          link: _layerLink,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _animationController,
              curve: widget.curve,
            ),
            child: Directionality(
              textDirection: widget.textDirection,
              // TODO: This is just a weird hack I found
              child: Builder(
                builder: (context) {
                  final scrollController = widget.scrollController;
                  final _child = Material(
                    type: MaterialType.transparency,
                    child: widget.content,
                  );

                  if (scrollController != null) {
                    return AnimatedBuilder(
                      animation: scrollController,
                      child: _child,
                      builder: (context, child) {
                        return TooltipOverlay(
                          animatedTransitionBuilder:
                              widget.animatedTransitionBuilder,
                          child: child!,
                          padding: widget.padding,
                          margin: widget.margin,
                          targetSize: targetInformation.size,
                          target: targetInformation.target,
                          offset: widget.offset,
                          preferredDirection: widget.preferredDirection,
                          offsetToTarget: targetInformation.offsetToTarget,
                          borderRadius: widget.borderRadius,
                          tailBaseWidth: widget.tailBaseWidth,
                          tailLength: widget.tailLength,
                          backgroundColor:
                              widget.backgroundColor ?? theme.cardColor,
                          textDirection: widget.textDirection,
                          shadow: widget.shadow ?? defaultShadow,
                          elevation: widget.elevation,
                          scrollPosition: scrollController.position,
                        );
                      },
                    );
                  }

                  return TooltipOverlay(
                    animatedTransitionBuilder: widget.animatedTransitionBuilder,
                    child: _child,
                    padding: widget.padding,
                    margin: widget.margin,
                    targetSize: targetInformation.size,
                    target: targetInformation.target,
                    offset: widget.offset,
                    preferredDirection: widget.preferredDirection,
                    offsetToTarget: targetInformation.offsetToTarget,
                    borderRadius: widget.borderRadius,
                    tailBaseWidth: widget.tailBaseWidth,
                    tailLength: widget.tailLength,
                    backgroundColor: widget.backgroundColor ?? theme.cardColor,
                    textDirection: widget.textDirection,
                    shadow: widget.shadow ?? defaultShadow,
                    elevation: widget.elevation,
                    scrollPosition: null,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
    _skrim = OverlayEntry(
      builder: (BuildContext context) {
        return GestureDetector(
          child: const SizedBox.expand(),
          behavior: HitTestBehavior.translucent,
          onTap: hideTooltip,
        );
      },
    );

    final overlay = Overlay.of(context);

    if (overlay == null) {
      throw StateError('Cannot find the overlay for the context $context');
    }

    setState(() {
      overlay.insert(_skrim!);
      overlay.insert(_entry!, above: _skrim);
    });
  }
}

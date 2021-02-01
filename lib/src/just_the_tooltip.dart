import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/tooltip_overlay.dart';

class JustTheTooltip extends StatefulWidget {
  final Widget content;

  final Widget child;

  final AxisDirection preferredDirection;

  final Duration fadeInDuration;

  final Duration fadeOutDuration;

  final Curve curve;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final double offset;

  final double elevation;

  final BorderRadiusGeometry borderRadius;

  final double tailLength;

  final double tailBaseWidth;

  final Color? color;

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
    this.color,
  });

  @override
  _SimpleTooltipState createState() => _SimpleTooltipState();
}

class _SimpleTooltipState extends State<JustTheTooltip>
    with SingleTickerProviderStateMixin {
  final _layerLink = LayerLink();
  late final AnimationController _animationController;
  OverlayEntry? _entry;
  OverlayEntry? _skrim;

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
    // TODO: Figure out how to rebuild the tooltip without opening and closing
    // it again
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
        onTap: _entry == null ? _showTooltip : null,
        child: widget.child,
      ),
    );
  }

  Future<void> _showTooltip() async {
    _createOverlayEntries();

    await _animationController.forward();
  }

  void _createOverlayEntries() {
    final box = context.findRenderObject() as RenderBox?;

    if (box == null) {
      throw 'Cannot find the box for the given object with context $context';
    }
    final boxSize = box.getDryLayout(BoxConstraints.tightForFinite());
    final target = box.localToGlobal(box.size.center(Offset.zero));
    final offsetToTarget = Offset(
      -target.dx + box.size.width / 2,
      -target.dy + box.size.height / 2,
    );

    final entry = Directionality(
      textDirection: Directionality.of(context),
      child: TooltipOverlay(
        content: widget.content,
        padding: widget.padding,
        margin: widget.margin,
        boxSize: boxSize,
        target: target,
        offset: widget.offset,
        preferredDirection: widget.preferredDirection,
        link: _layerLink,
        offsetToTarget: offsetToTarget,
        elevation: widget.elevation,
        borderRadius: widget.borderRadius,
        tailBaseWidth: widget.tailBaseWidth,
        tailLength: widget.tailLength,
        color: widget.color,
        animation: CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
        ),
      ),
    );

    // TODO: This needs a raw gesture detector probably so scroll events still
    // work
    final skrim = GestureDetector(
      child: SizedBox.expand(),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _entry?.remove();
        _skrim?.remove();

        setState(() {
          _entry = null;
          _skrim = null;
        });
      },
    );

    _entry = OverlayEntry(builder: (BuildContext context) => entry);
    _skrim = OverlayEntry(builder: (BuildContext context) => skrim);

    final overlay = Overlay.of(context);

    if (overlay == null) {
      throw 'Cannot find the overlay for the context $context';
    }

    setState(() {
      overlay.insert(_skrim!);
      overlay.insert(_entry!, above: _skrim);
    });
  }
}

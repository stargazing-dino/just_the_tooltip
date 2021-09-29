part of './just_the_tooltip.dart';

/// A Tooltip widget that delegates to creation and use of the tooltip and
/// skrim to the outer [JustTheTooltipArea]. This class is useless if not
/// nested within a [JustTheTooltipArea].
///
/// {@macro just_the_tooltip.overlay.constructor}
class JustTheTooltipEntry extends StatefulWidget implements JustTheInterface {
  const JustTheTooltipEntry({
    Key? key,
    required this.content,
    required this.child,
    this.controller,
    this.isModal = false,
    this.waitDuration,
    this.showDuration,
    this.triggerMode,
    this.enableFeedback,
    this.hoverShowDuration,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 75),
    this.preferredDirection = AxisDirection.down,
    this.curve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(8.0),
    this.offset = 0.0,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.tailLength = 16.0,
    this.tailBaseWidth = 32.0,
    this.tailBuilder = JustTheInterface.defaultTailBuilder,
    this.animatedTransitionBuilder =
        JustTheInterface.defaultAnimatedTransitionBuilder,
    this.backgroundColor,
    this.textDirection = TextDirection.ltr,
    this.shadow,
    this.showWhenUnlinked = false,
    this.scrollController,
  }) : super(key: key);

  @override
  final JustTheController? controller;

  @override
  final Widget content;

  @override
  final Widget child;

  @override
  final bool isModal;

  @override
  final Duration? waitDuration;

  @override
  final Duration? showDuration;

  @override
  final TooltipTriggerMode? triggerMode;

  @override
  final bool? enableFeedback;

  @override
  final Duration? hoverShowDuration;

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

  @override
  final TailBuilder tailBuilder;

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

  @override
  _JustTheTooltipEntryState createState() => _JustTheTooltipEntryState();
}

class _JustTheTooltipEntryState extends _JustTheTooltipState<Widget> {
  InheritedTooltipArea? area;

  @override
  Widget? get entry => area?.data.entry;

  @override
  Widget? get skrim => area?.data.skrim;

  @override
  void didChangeDependencies() {
    final _area =
        context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea>();

    if (_area != null) {
      area = _area;
    }

    super.didChangeDependencies();
  }

  @override
  Future<bool> ensureTooltipVisible() async {
    cancelShowTimer();

    if (hasEntry) {
      cancelHideTimer();

      // This checks if the current entry and the entry from the area are the
      // same
      if (entry!.key == entryKey) {
        await _animationController.forward();
        return false; // Already visible.
      } else {
        _animationController.reset();
        return true; // Wrong tooltip was visible
      }
    }

    _createNewEntries();
    await _animationController.forward();
    return true;
  }

  @override
  void _createNewEntries() {
    final entry = _createEntry();
    final skrim = _createSkrim();

    final tooltipArea = JustTheTooltipArea.of(context);

    // TODO: This looks anti-pattern.
    tooltipArea.setState(() {
      tooltipArea.skrim = skrim;
      tooltipArea.entry = entry;
    });
  }

  @override
  void _removeEntries() {
    cancelHideTimer();
    cancelShowTimer();

    // TODO: We should instead be sending up events instead of directly
    // modifying the area's state.
    final tooltipArea = JustTheTooltipArea.of(context);

    tooltipArea.removeEntries();
  }
}

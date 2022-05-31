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
    this.onDismiss,
    this.onShow,
    this.controller,
    this.isModal = false,
    this.waitDuration,
    this.showDuration,
    this.triggerMode,
    this.barrierDismissible = true,
    this.enableFeedback,
    this.hoverShowDuration,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 75),
    this.preferredDirection = AxisDirection.down,
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
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
  final VoidCallback? onDismiss;

  @override
  final VoidCallback? onShow;

  @override
  final bool isModal;

  @override
  final Duration? waitDuration;

  @override
  final Duration? showDuration;

  @override
  final TooltipTriggerMode? triggerMode;

  @override
  final bool barrierDismissible;

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
  final Curve reverseCurve;

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

// TODO: I think I want notifications instead... I'm really not sure
// https://stackoverflow.com/a/65854697/8213910
class _JustTheTooltipEntryState extends _JustTheTooltipState<Widget> {
  InheritedTooltipArea? area;

  @override
  Widget? get entry => area?.data.entry.value;

  @override
  Widget? get skrim => area?.data.skrim.value;

  @override
  void didChangeDependencies() {
    // I must save a reference to the ancestor here because this is not callable
    // in dispose.
    area = context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea>();

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

    tooltipArea.setEntries(entry: entry, skrim: skrim);
  }

  void _updateEntries() {
    final entry = _createEntry();
    final skrim = _createSkrim();

    final tooltipArea = JustTheTooltipArea.of(context);

    tooltipArea.updateEntries(entry: entry, skrim: skrim);
  }

  @override
  void _removeEntries() {
    cancelHideTimer();
    cancelShowTimer();

    area?.data.removeEntries();
  }

  @override
  void didUpdateWidget(covariant JustTheInterface oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateEntries();
    });

    super.didUpdateWidget(oldWidget);
  }
}

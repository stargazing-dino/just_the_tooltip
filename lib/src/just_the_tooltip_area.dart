import 'package:flutter/material.dart';

/// The interface for a tooltip builder. This is useful when the user wants to
/// insert the tooltip into a stack rather than an overlay
typedef TooltipBuilder = Widget Function(
  BuildContext context,
  Widget? tooltip,

  /// This widget should be placed behind the tooltip. When tapped, it will
  /// collapse the tooltip. When, isModal is set to false, this will always be
  /// null
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
  bool updateShouldNotify(covariant InheritedTooltipArea oldWidget) =>
      data != oldWidget.data;
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
            'JustTheTooltip.entry children inside a JustTheTooltipArea',
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

// FIXME: This is a very flawed idea to be able to get the state of this
// widget by calling `JustTheTooltipArea.of(context)`. It shouldn't be possible
// or there should be a layer of abstraction between.
class _JustTheTooltipAreaState extends State<JustTheTooltipArea> {
  Widget? entry;

  Widget? skrim;

  void removeEntries() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          entry = null;
          skrim = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTooltipArea(
      data: this,
      // This Builder allows direct children to call `JustTheTooltipArea.of`
      // without requiring a builder themselves.
      child: Builder(
        builder: (context) {
          return widget.builder(
            context,
            entry,
            skrim,
          );
        },
      ),
    );
  }
}

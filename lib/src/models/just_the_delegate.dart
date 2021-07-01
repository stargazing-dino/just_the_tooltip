import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

abstract class JustTheDelegate {
  JustTheDelegate({this.key});

  dynamic get entry;

  dynamic get skrim;

  bool get hasEntry => entry != null;

  bool get hasSkrim => skrim != null;

  Key? key;

  Key? get entryKey {
    final _key = key;
    return _key == null ? null : ValueKey('__entry_${key}__');
  }

  Key? get skrimKey {
    final _key = key;
    return _key == null ? null : Key('__skrim_${key}__');
  }
}

class JustTheEntryDelegate extends JustTheDelegate {
  @override
  Widget? get entry {
    final _context = context;
    return _context == null ? null : JustTheTooltipArea.of(_context).entry;
  }

  @override
  Widget? get skrim {
    final _context = context;
    return _context == null ? null : JustTheTooltipArea.of(_context).entry;
  }

  BuildContext? context;

  InheritedTooltipArea? area;

  JustTheEntryDelegate({
    required this.context,
    this.area,
    Key? key,
  }) : super(key: key);
}

class JustTheOverlayDelegate extends JustTheDelegate {
  @override
  OverlayEntry? entry;

  @override
  OverlayEntry? skrim;

  JustTheOverlayDelegate({
    this.entry,
    this.skrim,
    Key? key,
  }) : super(key: key);

  void markNeedsBuild() {
    entry?.markNeedsBuild();
    skrim?.markNeedsBuild();
  }
}

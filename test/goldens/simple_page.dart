import 'package:flutter/material.dart';
import 'package:just_the_tooltip/src/just_the_tooltip.dart';

class SimplePage extends StatelessWidget {
  final Widget content;

  final Alignment alignment;

  final AxisDirection preferredDirection;

  final bool isModal;

  const SimplePage({
    Key? key,
    required this.content,
    required this.preferredDirection,
    required this.isModal,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: SizedBox.expand(
          child: Align(
            alignment: alignment,
            child: JustTheTooltip(
              isModal: isModal,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              preferredDirection: preferredDirection,
              content: content,
              child: Material(
                color: Colors.grey.shade800,
                shape: const CircleBorder(),
                elevation: 4.0,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

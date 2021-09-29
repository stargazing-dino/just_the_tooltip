import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class DefaultPageExample extends StatefulWidget {
  const DefaultPageExample({Key? key}) : super(key: key);

  @override
  State<DefaultPageExample> createState() => _DefaultPageExampleState();
}

class _DefaultPageExampleState extends State<DefaultPageExample> {
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: const Icon(Icons.add),
            onPressed: () {
              tooltipController.showTooltip(immediately: true);
            },
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              tooltipController.hideTooltip(immediately: true);
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Align(
          alignment: Alignment.center,
          child: JustTheTooltip(
            controller: tooltipController,
            // fadeOutDuration: const Duration(seconds: 4),
            // fadeInDuration: const Duration(seconds: 4),
            tailLength: 20.0,
            tailBaseWidth: 50.0,
            isModal: true,
            preferredDirection: AxisDirection.up,
            margin: margin,
            borderRadius: BorderRadius.circular(16.0),
            offset: 0,
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
            content: const SizedBox(
              width: 100.0,
              height: 100.0,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class DefaultPageExample extends StatefulWidget {
  const DefaultPageExample({Key? key}) : super(key: key);

  @override
  State<DefaultPageExample> createState() => _DefaultPageExampleState();
}

class _DefaultPageExampleState extends State<DefaultPageExample> {
  final tooltipController = JustTheController();
  var length = 10.0;
  var color = Colors.pink;
  var alignment = Alignment.center;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      tooltipController.showTooltip(immediately: false);
    });

    tooltipController.addListener(() {
      print('controller: ${tooltipController.value}');
    });
    super.initState();
  }

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
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 1500),
          alignment: alignment,
          child: JustTheTooltip(
            backgroundColor: color,
            controller: tooltipController,
            // fadeOutDuration: const Duration(seconds: 4),
            // fadeInDuration: const Duration(seconds: 4),
            tailLength: length,
            tailBaseWidth: 20.0,
            isModal: true,
            preferredDirection: AxisDirection.up,
            margin: margin,
            borderRadius: BorderRadius.circular(8.0),
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
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200.0),
                child: const Text(
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

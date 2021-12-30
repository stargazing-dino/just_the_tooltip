import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import 'dart:math' as math;

class AnimatedBarrierExamplePage extends StatefulWidget {
  const AnimatedBarrierExamplePage({Key? key}) : super(key: key);

  @override
  State<AnimatedBarrierExamplePage> createState() =>
      _AnimatedBarrierExamplePageState();
}

class _AnimatedBarrierExamplePageState
    extends State<AnimatedBarrierExamplePage> {
  final tooltipController = JustTheController();
  var length = 10.0;
  var color = Colors.pink;
  var alignment = Alignment.center;

  Animation<double> _animation = kAlwaysDismissedAnimation;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      tooltipController.showTooltip(immediately: false);
    });

    print('----');
    print(tooltipController.value);
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
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              // Use the pythagorean theorem to get the diameter of the circle
              // that circumscribes the constraints.
              final double diameter = math.sqrt(
                      math.pow(constraints.maxHeight, 2) +
                          math.pow(constraints.maxWidth, 2));
              return ScaleTransition(
                scale: Tween<double>(begin: 0, end: 1).animate(_animation),
                child: OverflowBox(
                  maxWidth: diameter,
                  maxHeight: diameter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
            AnimatedAlign(
              duration: const Duration(milliseconds: 1500),
              alignment: alignment,
              child: JustTheTooltip(
                onShow: (showAnimation) {
                  setState(() {
                    print('Showing tooltip!');
                    _animation = showAnimation;
                    _animation.addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        print('Tooltip shown!');
                      }
                    });
                  });
                },
                onDismiss: (dismissAnimation) {
                  print('Dismissing tooltip!');
                  setState(() {
                    _animation = dismissAnimation;
                    _animation.addStatusListener((status) {
                      if (status == AnimationStatus.dismissed) {
                        print('Tooltip dismissed!');
                      }
                    });
                  });
                },
                backgroundColor: color,
                controller: tooltipController,
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
          ],
        ),
      ),
    );
  }
}

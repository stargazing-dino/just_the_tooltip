import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const DefaultPageExample(),
    );
  }
}

class DefaultPageExample extends StatelessWidget {
  const DefaultPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.all(0.0);

    return Scaffold(
      body: SizedBox.expand(
        child: Align(
          alignment: Alignment.center,
          child: JustTheTooltip(
            tailLength: 20.0,
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
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bacon ipsum dolor amet kevin turducken brisket pastrami, salami ribeye spare ribs tri-tip sirloin shoulder venison shank burgdoggen chicken pork belly. ',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScrollExamplePage extends StatelessWidget {
  const ScrollExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: List.generate(30, (index) {
          if (index == 15) {
            return JustTheTooltip(
              tailLength: 10.0,
              preferredDirection: AxisDirection.down,
              child: const Material(
                color: Colors.blue,
                shape: CircleBorder(),
                elevation: 4.0,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.touch_app,
                    color: Colors.white,
                  ),
                ),
              ),
              // This is necessary as otherwise the column would only be
              // constrained by the amount of vertical space
              content: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      color: Colors.blue,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quia ducimus eius magni voluptatibus ut veniam ducimus. Ullam ab qui voluptatibus quos est in. Maiores eos ab magni tempora praesentium libero. Voluptate architecto rerum vel sapiente ducimus aut cumque quibusdam. Consequatur illo et quos vel cupiditate quis dolores at.',
                    ),
                  ],
                ),
              ),
            );
          }

          return ListTile(title: Text('Item $index'));
        }),
      ),
    );
  }
}

class TooltipAreaExamplePage extends StatefulWidget {
  const TooltipAreaExamplePage({Key? key}) : super(key: key);

  @override
  State<TooltipAreaExamplePage> createState() => _TooltipAreaExamplePageState();
}

class _TooltipAreaExamplePageState extends State<TooltipAreaExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('It goes under me')),
      body: JustTheTooltipArea(
        builder: (context, tooltip, scrim) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              ListView(
                children: List.generate(
                  30,
                  (index) {
                    if (index == 15) {
                      return JustTheTooltipEntry(
                        tailLength: 10.0,
                        preferredDirection: AxisDirection.up,
                        margin: const EdgeInsets.all(16.0),
                        child: const Material(
                          color: Colors.blue,
                          shape: CircleBorder(),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.touch_app,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // This is necessary as otherwise the column would only be
                        // constrained by the amount of vertical space
                        content: IntrinsicHeight(
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                color: Colors.blue,
                                width: double.infinity,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Quia ducimus eius magni voluptatibus ut veniam ducimus. Ullam ab qui voluptatibus quos est in. Maiores eos ab magni tempora praesentium libero. Voluptate architecto rerum vel sapiente ducimus aut cumque quibusdam. Consequatur illo et quos vel cupiditate quis dolores at.',
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListTile(title: Text('Item $index'));
                  },
                ),
              ),
              if (scrim != null) scrim,
              if (tooltip != null) tooltip,
            ],
          );
        },
      ),
    );
  }
}

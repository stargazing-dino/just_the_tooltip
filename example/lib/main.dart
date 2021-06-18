import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  late final void Function() listener;
  AxisDirection direction = AxisDirection.right;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    listener = () {
      if (animation.value > .75) {
        if (direction != AxisDirection.right) {
          setState(() {
            direction = AxisDirection.right;
          });
        }
        return;
      }
      if (animation.value > .50) {
        if (direction != AxisDirection.down) {
          setState(() {
            direction = AxisDirection.down;
          });
        }
        return;
      }
      if (animation.value > .25) {
        if (direction != AxisDirection.left) {
          setState(() {
            direction = AxisDirection.left;
          });
        }
        return;
      } else {
        if (direction != AxisDirection.up) {
          setState(() {
            direction = AxisDirection.up;
          });
        }
      }
    };

    animation = CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    )..addListener(listener);

    Future<void>.delayed(const Duration(seconds: 2)).then((value) {
      controller.repeat();
    });

    super.initState();
  }

  @override
  void dispose() {
    animation.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.all(20.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // const SizedBox(height: 2.5),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: margin,
                      child: const Placeholder(),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: JustTheTooltip(
                        tailLength: 20.0,
                        // preferredDirection: AxisDirection.up,
                        preferredDirection: direction,
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
                            'Bacon ipsum dolor amet kevin turducken brisket pastrami, salami ribeye spare ribs tri-tip sirloin shoulder venison shank burgdoggen chicken pork belly. Short loin filet mignon shoulder rump beef ribs meatball kevin.',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Scroll example
// body: ListView.builder(
//   itemCount: 30,
//   itemBuilder: (context, index) {
//     if (index == 15) {
//       return JustTheTooltip(
//         tailLength: 10.0,
//         preferredDirection: AxisDirection.down,
//         child: const Material(
//           color: Colors.blue,
//           shape: CircleBorder(),
//           elevation: 4.0,
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.touch_app,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         // This is necessary as otherwise the column would only be
//         // constrained by the amount of vertical space
//         content: IntrinsicHeight(
//           child: Column(
//             children: [
//               Container(
//                 height: 120,
//                 color: Colors.blue,
//                 width: double.infinity,
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Quia ducimus eius magni voluptatibus ut veniam ducimus. Ullam ab qui voluptatibus quos est in. Maiores eos ab magni tempora praesentium libero. Voluptate architecto rerum vel sapiente ducimus aut cumque quibusdam. Consequatur illo et quos vel cupiditate quis dolores at.',
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListTile(title: Text('Item $index'));
//   },
// ),

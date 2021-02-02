import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Tooltip Components')),
        floatingActionButton: FloatingActionButton(
          child: Text('Close'),
          onPressed: () {},
        ),
        body: Column(
          children: [
            Spacer(),
            JustTheTooltip(
              preferredDirection: AxisDirection.up,
              child: Material(
                color: Colors.blue,
                shape: CircleBorder(),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quia ducimus eius magni voluptatibus ut veniam ducimus. Ullam ab qui voluptatibus quos est in. Maiores eos ab magni tempora praesentium libero. Voluptate architecto rerum vel sapiente ducimus aut cumque quibusdam. Consequatur illo et quos vel cupiditate quis dolores at.',
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ));
  }
}

// ListView.builder(
//   itemCount: 30,
//   itemBuilder: (context, index) {
//     if (index == 15) {
//       return JustTheTooltip(
//         preferredDirection: AxisDirection.left,
//         child: Material(
//           color: Colors.blue,
//           shape: CircleBorder(),
//           elevation: 4.0,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
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
//               Text(
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

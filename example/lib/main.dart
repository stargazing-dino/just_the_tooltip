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
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Text(
          'Close',
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () {},
      ),
      // body: Container(
      //   height: 100.0,
      //   width: 100.0,
      //   child: Placeholder(),
      // ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spacer(),
            // CustomSingleChildLayout(delegate: delegate)
            JustTheTooltip(
              tailLength: 10.0,
              preferredDirection: AxisDirection.down,
              margin: EdgeInsets.all(30.0),
              offset: 20.0,
              child: Material(
                color: Colors.grey.shade800,
                shape: const CircleBorder(),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              // This is necessary as otherwise the column would only be
              // constrained by the amount of vertical space
              content: Container(
                height: 99.0,
                width: 99.0,
                child: Placeholder(),
              ),
              // content: Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const SizedBox(height: 8),
              //     Text(
              //       'Quia ducimus eius magni voluptatibus ut veniam ducimus.'
              //       ' Ullam ab qui voluptatibus quos est in. Maiores eos ab'
              //       ' magni tempora praesentium libero. Voluptate architecto'
              //       ' rerum vel .',
              //     ),
              //   ],
              // ),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
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

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
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: Align(
            alignment: Alignment.center,
            child: JustTheTooltip(
              tailLength: 20.0,
              preferredDirection: AxisDirection.up,
              margin: const EdgeInsets.all(16.0),
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
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut auctor mi. Ut eros orci, rhoncus in cursus ut, mollis vel velit. Curabitur in finibus massa. Sed posuere placerat lectus non finibus. Quisque ultricies aliquet felis, sit amet semper nisi tempor at. Integer auctor quam neque. Nulla mollis justo ac ex vulputate, in mollis sem fringilla.',
                ),
              ),
            ),
          ),
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

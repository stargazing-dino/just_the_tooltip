import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          if (index == 15) {
            return JustTheTooltip(
              preferredDirection: AxisDirection.right,
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
              content: Text(
                'W',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}

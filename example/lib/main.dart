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
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          if (index == 15) {
            return JustTheTooltip(
              preferredDirection: AxisDirection.down,
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
                'Look at me and look at how big I am Look at me and look at how big I am Look at me and look at how big I am',
              ),
            );
          }

          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ScrollExamplePage extends StatelessWidget {
  const ScrollExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip follow example'),
      ),
      body: ListView(
        children: List.generate(30, (index) {
          if (index == 15) {
            return JustTheTooltip(
              tailLength: 10.0,
              isModal: true,
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
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
            );
          }

          return ListTile(title: Text('Item $index'));
        }),
      ),
    );
  }
}

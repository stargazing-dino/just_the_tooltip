import 'package:example/pages/default_page.dart';
import 'package:example/pages/scroll_page.dart';
import 'package:example/pages/tooltip_area_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomePage(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '':
          case 'default':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) => const DefaultPageExample(),
            );
          case 'scroll':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) => const ScrollExamplePage(),
            );
          case 'tooltipArea':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) => const TooltipAreaExamplePage(),
            );
          default:
            throw UnimplementedError();
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example app')),
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('default');
              },
              child: const Text('default'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                Navigator.of(context).pushNamed('scroll');
              },
              child: const Text('scroll'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.of(context).pushNamed('tooltipArea');
              },
              child: const Text('tooltipArea'),
            ),
          ],
        ),
      ),
    );
  }
}

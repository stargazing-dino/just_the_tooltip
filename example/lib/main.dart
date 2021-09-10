import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

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
              style: ElevatedButton.styleFrom(primary: Colors.amber.shade700),
              onPressed: () {
                Navigator.of(context).pushNamed('default');
              },
              child: const Text('default'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              onPressed: () {
                Navigator.of(context).pushNamed('scroll');
              },
              child: const Text('scroll'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal),
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

class DefaultPageExample extends StatefulWidget {
  const DefaultPageExample({Key? key}) : super(key: key);

  @override
  State<DefaultPageExample> createState() => _DefaultPageExampleState();
}

class _DefaultPageExampleState extends State<DefaultPageExample> {
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              tooltipController.showTooltip(immediately: true);
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              tooltipController.hideTooltip();
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Align(
          alignment: Alignment.center,
          child: JustTheTooltip(
            controller: tooltipController,
            // fadeOutDuration: const Duration(seconds: 4),
            // fadeInDuration: const Duration(seconds: 4),
            tailLength: 20.0,
            tailBaseWidth: 50.0,
            isModal: true,
            showDuration: const Duration(seconds: 5),
            preferredDirection: AxisDirection.left,
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
            content: Container(
              color: Colors.green,
              width: 100.0,
              height: 100.0,
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
      appBar: AppBar(
        title: const Text('Tooltip follow example'),
      ),
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

class TooltipAreaExamplePage extends StatefulWidget {
  const TooltipAreaExamplePage({Key? key}) : super(key: key);

  @override
  State<TooltipAreaExamplePage> createState() => _TooltipAreaExamplePageState();
}

class _TooltipAreaExamplePageState extends State<TooltipAreaExamplePage> {
  final titleController = TextEditingController(
    text: 'Lorem ipsum dolor',
  );
  final descriptionController = TextEditingController(
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
        'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
        'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ',
  );
  final scrollController = ScrollController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

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
                controller: scrollController,
                children: List.generate(
                  40,
                  (index) {
                    if (index == 15) {
                      return JustTheTooltip.entry(
                        scrollController: scrollController,
                        isModal: true,
                        tailLength: 20.0,
                        preferredDirection: AxisDirection.down,
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
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: Theme.of(context).textTheme.headline6,
                                controller: titleController,
                              ),
                              const SizedBox(height: 12.0),
                              TextField(
                                controller: descriptionController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () {},
                                      child: const Text('exercises'),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () {},
                                      child: const Text('course'),
                                    ),
                                  ),
                                ],
                              )
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

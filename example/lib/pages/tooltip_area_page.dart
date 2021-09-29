import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

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
                      return JustTheTooltipEntry(
                        scrollController: scrollController,
                        isModal: true,
                        tailLength: 10.0,
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

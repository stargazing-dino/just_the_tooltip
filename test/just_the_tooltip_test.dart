import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class SimplePage extends StatelessWidget {
  final Widget content;

  final Alignment alignment;

  final AxisDirection preferredDirection;

  const SimplePage({
    Key? key,
    required this.content,
    required this.preferredDirection,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: SizedBox.expand(
          child: Align(
            alignment: alignment,
            child: JustTheTooltip(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              preferredDirection: preferredDirection,
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
              content: content,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  const smallText = Text('hello');
  const largeText = Text(
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut auctor mi. Ut eros orci, rhoncus in cursus ut, mollis vel velit. Curabitur in finibus massa. Sed posuere placerat lectus non finibus. Quisque ultricies aliquet felis, sit amet semper nisi tempor at. Integer auctor quam neque. Nulla mollis justo ac ex vulputate, in mollis sem fringilla.',
  );
  // TODO: I couldn't get this to work because
  // const devices = [
  //   Device.phone,
  //   Device.iphone11,
  //   Device.tabletPortrait,
  //   Device.tabletLandscape,
  // ];

  Future<void> clickOnAddButton(WidgetTester tester) async {
    final icon = find.byIcon(Icons.add);

    expect(icon, findsOneWidget);
    await tester.tap(icon);
    await tester.pumpAndSettle();
  }

  group(
    'Goldens small phone - small text',
    () {
      testGoldens(
        'PreferredDirection up',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.up,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_up_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection down',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.down,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_down_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection left',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.left,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_left_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection right',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.right,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_right_sm_text',
          );
        },
      );
    },
  );

  group(
    'Goldens small phone - large text',
    () {
      testGoldens(
        'PreferredDirection up',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.up,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_up_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection down',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.down,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_down_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection left',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.left,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_left_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection right',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.right,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'sm_preferred_direction_right_lg_text',
          );
        },
      );
    },
  );

  group(
    'Goldens tablet - small text',
    () {
      testGoldens(
        'PreferredDirection up',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.up,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_up_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection down',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.down,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_down_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection left',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.left,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_left_sm_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection right',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.right,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_right_sm_text',
          );
        },
      );
    },
  );

  group(
    'Goldens tablet - large text',
    () {
      testGoldens(
        'PreferredDirection up',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.up,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_up_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection down',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.down,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_down_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection left',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.left,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_left_lg_text',
          );
        },
      );

      testGoldens(
        'PreferredDirection right',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: largeText,
              preferredDirection: AxisDirection.right,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'tablet_preferred_direction_right_lg_text',
          );
        },
      );
    },
  );

  group('Basic functionality', () {
    testWidgets('Opens and closes a tooltip', (tester) async {
      await tester.pumpWidget(
        const SimplePage(
          content: smallText,
          preferredDirection: AxisDirection.up,
        ),
      );

      await tester.tap(find.byType(GestureDetector));

      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);

      // TODO: I should just keep repeating this with random values
      await tester.tapAt(const Offset(100, 100));

      await tester.pumpAndSettle();

      expect(find.text('hello'), findsNothing);
    });
  });
}

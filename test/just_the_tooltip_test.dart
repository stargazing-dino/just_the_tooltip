import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void main() {
  final buttonContent = Material(
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
  );
  const devices = [
    Device.iphone11,
    Device.phone,
    Device.tabletLandscape,
    Device.tabletPortrait,
  ];
  const longTextPadded = Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut auctor mi. Ut eros orci, rhoncus in cursus ut, mollis vel velit. Curabitur in finibus massa. Sed posuere placerat lectus non finibus. Quisque ultricies aliquet felis, sit amet semper nisi tempor at. Integer auctor quam neque. Nulla mollis justo ac ex vulputate, in mollis sem fringilla.',
    ),
  );
  const holaText = 'Hola';
  const shortText = Text(holaText);

  Widget buildAligned(Widget child, {Alignment alignment = Alignment.center}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox.expand(
          child: Align(
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> basicOpen(Key key, WidgetTester tester) async {
    final finder = find.descendant(
      of: find.byKey(key),
      matching: find.byType(GestureDetector),
    );

    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  DeviceBuilder allAxisWithContent(Widget content, WidgetTester tester) {
    return DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addScenario(
        name: 'up',
        widget: JustTheTooltip(
          preferredDirection: AxisDirection.up,
          child: buttonContent,
          content: content,
        ),
        onCreate: (key) => basicOpen(key, tester),
      )
      ..addScenario(
        name: 'right',
        widget: JustTheTooltip(
          preferredDirection: AxisDirection.right,
          child: buttonContent,
          content: content,
        ),
        onCreate: (key) => basicOpen(key, tester),
      )
      ..addScenario(
        name: 'down',
        widget: JustTheTooltip(
          preferredDirection: AxisDirection.down,
          child: buttonContent,
          content: content,
        ),
        onCreate: (key) => basicOpen(key, tester),
      )
      ..addScenario(
        name: 'left',
        widget: JustTheTooltip(
          preferredDirection: AxisDirection.left,
          child: buttonContent,
          content: content,
        ),
        onCreate: (key) => basicOpen(key, tester),
      );
  }

  group('Basic functionality', () {
    testWidgets('Opens and closes a tooltip', (tester) async {
      await tester.pumpWidget(
        buildAligned(
          JustTheTooltip(
            child: buttonContent,
            content: shortText,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));

      await tester.pumpAndSettle();

      expect(find.text(holaText), findsOneWidget);

      // TODO: I should just keep repeating this with random values
      await tester.tapAt(const Offset(100, 100));

      await tester.pumpAndSettle();

      expect(find.text(holaText), findsNothing);
    });

    // testWidgets('Opens and closes a tooltip with animation', (tester) async {
    //   await tester.pumpWidget(
    //     buildAligned(
    //       JustTheTooltip(
    //         child: buttonContent,
    //         content: shortText,
    //         fadeInDuration: const Duration(milliseconds: 250),
    //         fadeOutDuration: const Duration(milliseconds: 250),
    //       ),
    //     ),
    //   );

    //   await tester.tap(find.byType(GestureDetector));

    //   expect(find.text(holaText), findsOneWidget);

    //   // TODO: I should just keep repeating this with random values
    //   await tester.tapAt(const Offset(100, 100));

    //   expect(find.text(holaText), findsNothing);
    // });
  });

  group('Goldens', () {
    testGoldens('PreferredDirection shortText', (tester) async {
      final gb = allAxisWithContent(shortText, tester);

      await tester.pumpWidgetBuilder(gb.build(), wrapper: buildAligned);
      await multiScreenGolden(
        tester,
        'small text',
        devices: devices,
        deviceSetup: (device, tester) async {
          await tester.tap(find.byType(GestureDetector));
          await tester.pumpAndSettle();
        },
      );
    });

    testGoldens('PreferredDirection longText', (tester) async {
      final gb = allAxisWithContent(longTextPadded, tester);

      await tester.pumpWidgetBuilder(gb.build(), wrapper: buildAligned);
      await multiScreenGolden(
        tester,
        'long text padded',
        devices: devices,
        deviceSetup: (device, tester) async {
          await tester.tap(find.byType(GestureDetector));
          await tester.pumpAndSettle();
        },
      );
    });
  });
}

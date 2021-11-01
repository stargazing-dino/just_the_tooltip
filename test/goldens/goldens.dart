import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'simple_page.dart';

Future<void> testTooltipGoldens() async {
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

  Future<TestGesture> hoverOnAddButton(WidgetTester tester) async {
    final icon = find.byIcon(Icons.add);

    expect(icon, findsOneWidget);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(icon));
    await tester.pumpAndSettle();

    return gesture;
  }

  Future<void> hoverOutOfAddButton(
    WidgetTester tester,
    TestGesture gesture,
  ) async {
    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
  }

  group(
    'Non-modal goldens small phone - small text',
    () {
      testGoldens(
        'PreferredDirection up',
        (tester) async {
          await tester.pumpWidgetBuilder(
            const SimplePage(
              content: smallText,
              preferredDirection: AxisDirection.up,
              isModal: false,
            ),
            surfaceSize: Device.phone.size,
          );

          final gesture = await hoverOnAddButton(tester);
          await screenMatchesGolden(
            tester,
            'goldens/hover_in_sm_preferred_direction_up_sm_text',
          );
          await hoverOutOfAddButton(tester, gesture);
          await screenMatchesGolden(
            tester,
            'goldens/hover_out_sm_preferred_direction_up_sm_text',
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
              isModal: false,
            ),
            surfaceSize: Device.phone.size,
          );

          final gesture = await hoverOnAddButton(tester);
          await screenMatchesGolden(
            tester,
            'goldens/hover_in_sm_preferred_direction_down_sm_text',
          );
          await hoverOutOfAddButton(tester, gesture);
          await screenMatchesGolden(
            tester,
            'goldens/hover_out_sm_preferred_direction_down_sm_text',
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
              isModal: false,
            ),
            surfaceSize: Device.phone.size,
          );

          final gesture = await hoverOnAddButton(tester);
          await screenMatchesGolden(
            tester,
            'goldens/hover_in_sm_preferred_direction_left_sm_text',
          );
          await hoverOutOfAddButton(tester, gesture);
          await screenMatchesGolden(
            tester,
            'goldens/hover_out_sm_preferred_direction_left_sm_text',
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
              isModal: false,
            ),
            surfaceSize: Device.phone.size,
          );

          final gesture = await hoverOnAddButton(tester);
          await screenMatchesGolden(
            tester,
            'goldens/hover_in_sm_preferred_direction_right_sm_text',
          );
          await hoverOutOfAddButton(tester, gesture);
          await screenMatchesGolden(
            tester,
            'goldens/hover_out_sm_preferred_direction_right_sm_text',
          );
        },
      );
    },
  );

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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_up_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_down_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_left_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_right_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_up_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_down_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_left_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.phone.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/sm_preferred_direction_right_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_up_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_down_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_left_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_right_sm_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_up_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_down_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_left_lg_text',
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
              isModal: true,
            ),
            surfaceSize: Device.tabletLandscape.size,
          );

          await clickOnAddButton(tester);

          await screenMatchesGolden(
            tester,
            'goldens/tablet_preferred_direction_right_lg_text',
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
          isModal: true,
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

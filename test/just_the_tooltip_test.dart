import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

void _ensureTooltipVisible(GlobalKey key) {
  // This function uses "as dynamic"to defeat the static analysis. In general
  // you want to avoid using this style in your code, as it will cause the
  // analyzer to be unable to help you catch errors.
  //
  // In this case, we do it because we are trying to call internal methods of
  // the tooltip code in order to test it. Normally, the state of a tooltip is a
  // private class, but by using a GlobalKey we can get a handle to that object
  // and by using "as dynamic" we can bypass the analyzer's type checks and call
  // methods that we aren't supposed to be able to know about.
  //
  // It's ok to do this in tests, but you really don't want to do it in
  // production code.
  // ignore: avoid_dynamic_calls
  (key.currentState as dynamic).ensureTooltipVisible();
}

const String tooltipText = 'TIP';

Finder _findTooltipContainer(String tooltipText) {
  return find.ancestor(
    of: find.text(tooltipText),
    matching: find.byType(Material),
  );
}

void main() {
  // Goldens are UI diff tests.
  // GoldenToolkit.runWithConfiguration(
  //   () async => await testTooltipGoldens(),
  //   config: GoldenToolkitConfiguration(
  //     // Currently, goldens are not generated/validated in CI for this repo.
  //     // We have settled on the goldens for this package being
  //     // captured/validated by developers running on MacOSX. We may revisit this
  //     // in the future if there is a reason to invest in more sophistication
  //     skipGoldenAssertion: () => !Platform.isMacOS,
  //   ),
  // );

  testWidgets('Does tooltip end up in the right place - center',
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      left: 300.0,
                      top: 0.0,
                      child: JustTheTooltip(
                        key: key,
                        offset: 20.0,
                        tailLength: 0.0,
                        content: const Text(tooltipText),
                        preferredDirection: AxisDirection.up,
                        child: const SizedBox(
                          width: 0.0,
                          height: 0.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
    _ensureTooltipVisible(key);

    // faded in, show timer started (and at 0.0)
    await tester.pump(const Duration(seconds: 2));

    /********************* 800x600 screen
     *      o            * y=0
     *      |            * }- 20.0 vertical offset, of which 10.0 is in the screen edge margin
     *   +----+          * \- (5.0 padding in height)
     *   |    |          * |- 20 height
     *   +----+          * /- (5.0 padding in height)
     *                   *
     *********************/

    final RenderBox tip = tester.renderObject(
      _findTooltipContainer(tooltipText),
    );
    final Offset tipInGlobal =
        tip.localToGlobal(tip.size.topCenter(Offset.zero));
    // The exact position of the left side depends on the font the test framework
    // happens to pick, so we don't test that.
    expect(tipInGlobal.dx, 300.0);
    expect(tipInGlobal.dy, 20.0);
  });

  testWidgets(
      'Does tooltip end up in the right place - center with padding outside overlay',
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        left: 300.0,
                        top: 0.0,
                        child: JustTheTooltip(
                          key: key,
                          content: const Text(tooltipText),
                          offset: 20.0,
                          tailLength: 0.0,
                          preferredDirection: AxisDirection.up,
                          child: const SizedBox(
                            width: 0.0,
                            height: 0.0,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    _ensureTooltipVisible(key);

    // faded in, show timer started (and at 0.0)
    await tester.pump(const Duration(seconds: 2));

    /************************ 800x600 screen
     *   ________________   * }- 20.0 padding outside overlay
     *  |    o           |  * y=0
     *  |    |           |  * }- 20.0 vertical offset, of which 10.0 is in the screen edge margin
     *  | +----+         |  * \- (5.0 padding in height)
     *  | |    |         |  * |- 20 height
     *  | +----+         |  * /- (5.0 padding in height)
     *  |________________|  *
     *                      * } - 20.0 padding outside overlay
     ************************/

    final RenderBox tip = tester.renderObject(
      _findTooltipContainer(tooltipText),
    );
    final Offset tipInGlobal =
        tip.localToGlobal(tip.size.topCenter(Offset.zero));
    // The exact position of the left side depends on the font the test framework
    // happens to pick, so we don't test that.
    expect(tipInGlobal.dx, 320.0);
    expect(tipInGlobal.dy, 40.0);
  });

  // testWidgets('Does tooltip end up in the right place - top left',
  //     (WidgetTester tester) async {
  //   final GlobalKey key = GlobalKey();
  //   await tester.pumpWidget(
  //     Directionality(
  //       textDirection: TextDirection.ltr,
  //       child: Overlay(
  //         initialEntries: <OverlayEntry>[
  //           OverlayEntry(
  //             builder: (BuildContext context) {
  //               return Stack(
  //                 children: <Widget>[
  //                   Positioned(
  //                     left: 0.0,
  //                     top: 0.0,
  //                     child: JustTheTooltip(
  //                       key: key,
  //                       content: const Text(tooltipText),
  //                       offset: 20.0,
  //                       tailLength: 0.0,
  //                       margin: EdgeInsets.all(5.0),
  //                       preferredDirection: AxisDirection.up,
  //                       child: const SizedBox(
  //                         width: 0.0,
  //                         height: 0.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   _ensureTooltipVisible(key);

  //   // faded in, show timer started (and at 0.0)
  //   await tester.pump(const Duration(seconds: 2));

  //   /********************* 800x600 screen
  //    *o                  * y=0
  //    *|                  * }- 20.0 vertical offset, of which 10.0 is in the screen edge margin
  //    *+----+             * \- (5.0 padding in height)
  //    *|    |             * |- 20 height
  //    *+----+             * /- (5.0 padding in height)
  //    *                   *
  //    *********************/

  //   final RenderBox tip = tester.renderObject(
  //     _findTooltipContainer(tooltipText),
  //   );
  //   expect(tip.size.height,
  //       equals(24.0)); // 14.0 height + 5.0 padding * 2 (top, bottom)
  //   expect(tip.localToGlobal(tip.size.topLeft(Offset.zero)),
  //       equals(const Offset(10.0, 20.0)));
  // });
}

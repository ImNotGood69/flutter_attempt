// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets(
    'Switch toggles between six-inch and footlong in the order display',
    (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // find the size switch by key
      final Finder sizeSwitchFinder = find.byKey(const Key('size_switch'));
      expect(sizeSwitchFinder, findsOneWidget);

      // verify initial switch value is true (footlong)
      final Switch sBefore = tester.widget<Switch>(sizeSwitchFinder);
      expect(sBefore.value, isTrue);

      // toggle the switch
      await tester.tap(sizeSwitchFinder);
      await tester.pumpAndSettle();

      // after toggle the order display should show six-inch
      expect(find.textContaining('six-inch'), findsWidgets);

      // switch value should now be false
      final Switch sAfter = tester.widget<Switch>(sizeSwitchFinder);
      expect(sAfter.value, isFalse);
    },
  );
}

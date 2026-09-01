// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:kids_learn/app.dart';

void main() {
  testWidgets('Home screen displays learning topics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KidsLearnApp());

    expect(find.text('Учи со Забава!'), findsOneWidget);
    expect(find.text('Животни'), findsOneWidget);
    expect(find.text('Азбука'), findsOneWidget);
  });
}

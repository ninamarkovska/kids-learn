// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kids_learn/app.dart';
import 'package:kids_learn/core/accessibility/accessibility_settings.dart';

void main() {
  testWidgets('Home screen displays learning topics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KidsLearnApp());

    expect(find.text('Учи со Забава!'), findsOneWidget);
    expect(find.text('Животни'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Азбука'), 150);
    expect(find.text('Азбука'), findsOneWidget);
    expect(find.text('Пристапност'), findsOneWidget);
  });

  testWidgets('color mode can be selected from accessibility settings', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const KidsLearnApp());

    await tester.tap(find.text('Пристапност'));
    await tester.pumpAndSettle();

    expect(find.text('Режим на бои'), findsOneWidget);
    expect(find.text('Деутеранопија'), findsOneWidget);

    await tester.tap(find.text('Деутеранопија'));
    await tester.pumpAndSettle();

    final homeContext = tester.element(find.text('Учи со Забава!'));
    expect(
      AccessibilityScope.of(homeContext).colorVisionMode,
      ColorVisionMode.deuteranopia,
    );
    expect(find.text('Избрано'), findsOneWidget);

    Navigator.of(homeContext).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Животни'));
    await tester.pumpAndSettle();

    final animalsContext = tester.element(find.text('🐾 Животни'));
    expect(
      AccessibilityScope.of(animalsContext).colorVisionMode,
      ColorVisionMode.deuteranopia,
    );

    Navigator.of(animalsContext).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Пристапност'));
    await tester.pumpAndSettle();
    expect(find.text('Избрано'), findsOneWidget);
  });
}

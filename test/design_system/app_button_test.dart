import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders label and responds to tap', (
    WidgetTester tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(label: 'Primary', onPressed: () => pressed = true),
        ),
      ),
    );

    expect(find.text('Primary'), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });

  testWidgets('AppButton shows progress indicator when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppButton(label: 'Loading', onPressed: null, isLoading: true),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

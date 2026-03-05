import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/app_card.dart';

void main() {
  testWidgets('AppCard renders child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCard(
            child: Text('Content'),
          ),
        ),
      ),
    );

    expect(find.text('Content'), findsOneWidget);
  });
}


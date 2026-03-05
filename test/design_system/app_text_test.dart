import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/app_text.dart';

void main() {
  testWidgets('AppDisplayText and AppBodyText render text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              AppDisplayText('Headline'),
              AppBodyText('Body'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Headline'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });
}


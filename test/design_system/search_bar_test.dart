import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/search_bar.dart';

void main() {
  testWidgets('AppSearchBar calls onChanged', (WidgetTester tester) async {
    var last = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchBar(
            hintText: 'Search products',
            onChanged: (String value) => last = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'phone');
    await tester.pump();

    expect(last, 'phone');
  });
}


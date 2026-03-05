import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/category_chip.dart';

void main() {
  testWidgets('CategoryChip toggles selection', (WidgetTester tester) async {
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryChip(
            label: 'Shoes',
            selected: selected,
            onSelected: (bool value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CategoryChip));
    await tester.pumpAndSettle();

    expect(selected, isTrue);
  });
}


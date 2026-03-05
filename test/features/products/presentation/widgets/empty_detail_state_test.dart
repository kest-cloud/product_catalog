import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/features/products/presentation/widgets/empty_detail_state.dart';

void main() {
  group('EmptyDetailState', () {
    testWidgets('shows select a product title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyDetailState())),
      );

      expect(find.text('Select a product'), findsOneWidget);
      expect(
        find.text('Choose an item from the list to view details.'),
        findsOneWidget,
      );
    });

    testWidgets('renders without overflowing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyDetailState())),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}

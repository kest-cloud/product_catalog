import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/features/products/presentation/widgets/empty_detail_state.dart';

void main() {
  testWidgets('EmptyDetailState golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const Scaffold(body: Center(child: EmptyDetailState())),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(EmptyDetailState),
      matchesGoldenFile('empty_detail_state_light.png'),
    );
  });
}

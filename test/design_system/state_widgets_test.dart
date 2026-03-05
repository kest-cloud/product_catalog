import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/empty_state.dart';
import 'package:product_catalog/design_system/widgets/error_state.dart';
import 'package:product_catalog/design_system/widgets/loading_skeleton.dart';

void main() {
  testWidgets('ErrorState shows message and retry button', (
    WidgetTester tester,
  ) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorState(
            message: 'Something went wrong',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(retried, isTrue);
  });

  testWidgets('EmptyState shows title and subtitle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'No products',
            subtitle: 'Try adjusting your filters',
          ),
        ),
      ),
    );

    expect(find.text('No products'), findsOneWidget);
    expect(find.text('Try adjusting your filters'), findsOneWidget);
  });

  testWidgets('LoadingSkeleton renders box', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoadingSkeleton(width: 100))),
    );

    expect(find.byType(LoadingSkeleton), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/app/app.dart';
import 'package:product_catalog/core/di/app_providers.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await setupLocator();

    await tester.pumpWidget(const ProductCatalogApp());
    // Allow router to build the initial route and in-flight requests to settle.
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Basic smoke test – app should render the root widget.
    expect(find.byType(ProductCatalogApp), findsOneWidget);
  });
}

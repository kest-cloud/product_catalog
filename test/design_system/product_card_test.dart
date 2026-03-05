import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/design_system/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard displays basic product info', (
    WidgetTester tester,
  ) async {
    final ProductCardModel model = ProductCardModel(
      id: '1',
      name: 'Futuristic Sneakers',
      priceLabel: '\$199',
      imageUrl: 'https://example.com/image.png',
      subtitle: 'Limited edition',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProductCard(model: model)),
      ),
    );

    expect(find.text('Futuristic Sneakers'), findsOneWidget);
    expect(find.text('\$199'), findsOneWidget);
    expect(find.text('Limited edition'), findsOneWidget);
  });
}

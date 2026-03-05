import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/features/products/data/domain/entity/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses valid JSON with all fields', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 1,
        'title': 'Test Product',
        'description': 'A description',
        'category': 'electronics',
        'price': 99.99,
        'brand': 'BrandX',
        'thumbnail': 'https://example.com/thumb.png',
        'images': <String>[
          'https://example.com/1.png',
          'https://example.com/2.png',
        ],
      };

      final Product product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.title, 'Test Product');
      expect(product.description, 'A description');
      expect(product.category, 'electronics');
      expect(product.price, 99.99);
      expect(product.brand, 'BrandX');
      expect(product.thumbnail, 'https://example.com/thumb.png');
      expect(product.images, hasLength(2));
      expect(product.priceLabel, '\$99.99');
      expect(product.imageUrl, 'https://example.com/thumb.png');
    });

    test('handles string id', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 'abc-123',
        'title': 'Item',
        'price': 10,
      });
      expect(product.id, 'abc-123');
    });

    test('handles missing optional fields with defaults', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 2,
        'title': 'Minimal',
        'price': 5.0,
      });

      expect(product.id, '2');
      expect(product.title, 'Minimal');
      expect(product.price, 5.0);
      expect(product.description, isNull);
      expect(product.category, isNull);
      expect(product.brand, isNull);
      expect(product.thumbnail, isNull);
      expect(product.images, isEmpty);
      expect(product.imageUrl, '');
    });

    test('uses Unknown when title is empty', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 3,
        'title': '',
        'price': 0,
      });
      expect(product.title, 'Unknown');
    });

    test('clamps negative price to 0', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 4,
        'title': 'Negative',
        'price': -10,
      });
      expect(product.price, 0);
      expect(product.hasValidPrice, isFalse);
      expect(product.priceLabel, 'Price unavailable');
    });

    test('handles bad price type via fallback', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 5,
        'title': 'Bad price',
        'price': 'invalid',
      });
      expect(product.price, 0);
      expect(product.priceLabel, 'Price unavailable');
    });

    test('brandLabel returns Unknown brand when brand missing', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 7,
        'title': 'No brand',
        'price': 10,
      });
      expect(product.brand, isNull);
      expect(product.brandLabel, 'Unknown brand');
    });

    test('imageUrl uses first image when thumbnail missing', () {
      final Product product = Product.fromJson(<String, dynamic>{
        'id': 6,
        'title': 'No thumb',
        'price': 1,
        'images': <String>['https://example.com/a.png'],
      });
      expect(product.thumbnail, isNull);
      expect(product.imageUrl, 'https://example.com/a.png');
    });
  });
}

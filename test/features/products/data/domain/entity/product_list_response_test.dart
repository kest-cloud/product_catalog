import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';

void main() {
  group('ProductListResponse.fromJson', () {
    test('parses valid paginated response', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'products': <Map<String, dynamic>>[
          <String, dynamic>{'id': 1, 'title': 'A', 'price': 10},
          <String, dynamic>{'id': 2, 'title': 'B', 'price': 20},
        ],
        'total': 100,
        'skip': 0,
        'limit': 20,
      };

      final ProductListResponse response = ProductListResponse.fromJson(json);

      expect(response.products, hasLength(2));
      expect(response.products[0].title, 'A');
      expect(response.products[1].title, 'B');
      expect(response.total, 100);
      expect(response.skip, 0);
      expect(response.limit, 20);
      expect(response.hasMore, isTrue);
    });

    test('hasMore is false when skip + length >= total', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'products': <Map<String, dynamic>>[
          <String, dynamic>{'id': 1, 'title': 'Only', 'price': 1},
        ],
        'total': 1,
        'skip': 0,
        'limit': 20,
      };
      final ProductListResponse response = ProductListResponse.fromJson(json);
      expect(response.hasMore, isFalse);
    });

    test('handles missing products array as empty list', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'total': 0,
        'skip': 0,
        'limit': 20,
      };
      final ProductListResponse response = ProductListResponse.fromJson(json);
      expect(response.products, isEmpty);
      expect(response.total, 0);
    });

    test('handles invalid product entries by filtering empty id', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'products': <Map<String, dynamic>>[
          <String, dynamic>{'id': 1, 'title': 'Valid', 'price': 1},
          <String, dynamic>{'title': 'No id', 'price': 2},
        ],
        'total': 2,
        'skip': 0,
        'limit': 20,
      };
      final ProductListResponse response = ProductListResponse.fromJson(json);
      expect(response.products, hasLength(1));
      expect(response.products[0].title, 'Valid');
    });

    test('uses fallback for bad total/skip/limit', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'products': <Map<String, dynamic>>[],
        'total': 'bad',
        'skip': null,
        'limit': -5,
      };
      final ProductListResponse response = ProductListResponse.fromJson(json);
      expect(response.total, 0);
      expect(response.skip, 0);
      expect(response.limit, 20);
    });
  });
}

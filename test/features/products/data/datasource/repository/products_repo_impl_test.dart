import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/features/products/data/datasource/products_remote.dart';
import 'package:product_catalog/features/products/data/datasource/repository/products_repo_impl.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';

void main() {
  late FakeProductsRemote fakeRemote;
  late ProductsRepoImpl repo;

  setUp(() {
    fakeRemote = FakeProductsRemote();
    repo = ProductsRepoImpl(remote: fakeRemote);
  });

  group('ProductsRepoImpl.getProducts', () {
    test('returns Right with parsed data when remote returns 200', () async {
      fakeRemote.productsResponse = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
        data: <String, dynamic>{
          'products': <Map<String, dynamic>>[
            <String, dynamic>{'id': 1, 'title': 'P1', 'price': 9.99},
          ],
          'total': 1,
          'skip': 0,
          'limit': 20,
        },
      );

      final result = await repo.getProducts(skip: 0, limit: 20);

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('expected Right'), (ProductListResponse r) {
        expect(r.products, hasLength(1));
        expect(r.products[0].title, 'P1');
        expect(r.total, 1);
      });
    });

    test('returns Left when remote returns non-200', () async {
      fakeRemote.productsResponse = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 500,
      );

      final result = await repo.getProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l.message, contains('500')),
        (r) => fail('expected Left'),
      );
    });

    test('returns Left when response data is null', () async {
      fakeRemote.productsResponse = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
        data: null,
      );

      final result = await repo.getProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l.message, contains('Empty')),
        (r) => fail('expected Left'),
      );
    });

    test('returns Left when remote throws', () async {
      fakeRemote.productsThrow = true;

      final result = await repo.getProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l.message, isNotEmpty),
        (r) => fail('expected Left'),
      );
    });
  });

  group('ProductsRepoImpl.getCategories', () {
    test('returns Right with list when remote returns 200', () async {
      fakeRemote.categoriesResponse = Response<List<String>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
        data: <String>['cat1', 'cat2'],
      );

      final result = await repo.getCategories();

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('expected Right'), (List<String> list) {
        expect(list, <String>['cat1', 'cat2']);
      });
    });

    test('returns Right with empty list when data is null', () async {
      fakeRemote.categoriesResponse = Response<List<String>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
        data: null,
      );

      final result = await repo.getCategories();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('expected Right'),
        (List<String> list) => expect(list, isEmpty),
      );
    });

    test('returns Left when remote returns non-200', () async {
      fakeRemote.categoriesResponse = Response<List<String>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 404,
      );

      final result = await repo.getCategories();

      expect(result.isLeft(), isTrue);
    });
  });
}

class FakeProductsRemote implements ProductsRemote {
  Response<Map<String, dynamic>>? productsResponse;
  Response<List<String>>? categoriesResponse;
  bool productsThrow = false;
  bool categoriesThrow = false;

  @override
  Future<Response<Map<String, dynamic>>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  }) async {
    if (productsThrow) throw Exception('network error');
    return productsResponse!;
  }

  @override
  Future<Response<List<String>>> getCategories() async {
    if (categoriesThrow) throw Exception('network error');
    return categoriesResponse!;
  }

  @override
  Future<Response<Map<String, dynamic>>> getProduct(String id) async {
    throw UnimplementedError('getProduct not used in repo impl tests');
  }
}

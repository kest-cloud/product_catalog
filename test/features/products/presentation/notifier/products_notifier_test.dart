import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/core/network/failure.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/notifier/product_list_state.dart';
import 'package:product_catalog/features/products/presentation/notifier/products_notifier.dart';

void main() {
  group('ProductsNotifier', () {
    test(
      'loadInitial sets state to Loaded when repo returns Right with products',
      () async {
        const Product p = Product(id: '1', title: 'Item', price: 10);
        const ProductListResponse data = ProductListResponse(
          products: <Product>[p],
          total: 1,
          skip: 0,
          limit: 20,
        );
        final FakeProductsRepo repo = FakeProductsRepo(
          getProductsResult: Right(data),
          getCategoriesResult: const Right(<String>['cat1']),
        );
        final ProductsNotifier notifier = ProductsNotifier(repo: repo);

        await notifier.loadInitial();

        expect(notifier.state, isA<ProductListLoaded>());
        final ProductListLoaded loaded = notifier.state as ProductListLoaded;
        expect(loaded.products, hasLength(1));
        expect(loaded.products[0].title, 'Item');
        expect(notifier.total, 1);
        expect(notifier.hasMore, isFalse);
        expect(notifier.categories, <String>['cat1']);
      },
    );

    test('loadInitial sets state to Error when repo returns Left', () async {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Left(Failure(message: 'Server error')),
        getCategoriesResult: const Right(<String>[]),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);

      await notifier.loadInitial();

      expect(notifier.state, isA<ProductListError>());
      expect((notifier.state as ProductListError).message, 'Server error');
    });

    test(
      'loadInitial sets state to Empty when repo returns empty list',
      () async {
        final ProductListResponse data = const ProductListResponse(
          products: <Product>[],
          total: 0,
          skip: 0,
          limit: 20,
        );
        final FakeProductsRepo repo = FakeProductsRepo(
          getProductsResult: Right(data),
          getCategoriesResult: const Right(<String>[]),
        );
        final ProductsNotifier notifier = ProductsNotifier(repo: repo);

        await notifier.loadInitial();

        expect(notifier.state, isA<ProductListEmpty>());
      },
    );

    test('loadMore appends products and updates state', () async {
      const Product p1 = Product(id: '1', title: 'A', price: 1);
      const Product p2 = Product(id: '2', title: 'B', price: 2);
      const ProductListResponse page1 = ProductListResponse(
        products: <Product>[p1],
        total: 2,
        skip: 0,
        limit: 20,
      );
      const ProductListResponse page2 = ProductListResponse(
        products: <Product>[p2],
        total: 2,
        skip: 1,
        limit: 20,
      );
      int getProductsCallCount = 0;
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: null,
        getCategoriesResult: const Right(<String>[]),
        getProductsCallback: () {
          getProductsCallCount++;
          return getProductsCallCount == 1
              ? Future.value(Right(page1))
              : Future.value(Right(page2));
        },
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);
      await notifier.loadInitial();
      expect(notifier.products, hasLength(1));

      await notifier.loadMore();

      expect(notifier.products, hasLength(2));
      expect(notifier.products[0].title, 'A');
      expect(notifier.products[1].title, 'B');
      expect(notifier.total, 2);
    });

    test('setCategory updates selectedCategory and triggers load', () async {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Right(
          ProductListResponse(
            products: <Product>[],
            total: 0,
            skip: 0,
            limit: 20,
          ),
        ),
        getCategoriesResult: const Right(<String>['phones', 'laptops']),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);
      await notifier.loadInitial();

      notifier.setCategory('phones');

      expect(notifier.selectedCategory, 'phones');
    });

    test('clearCategory sets selectedCategory to null', () async {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Right(
          ProductListResponse(
            products: <Product>[],
            total: 0,
            skip: 0,
            limit: 20,
          ),
        ),
        getCategoriesResult: const Right(<String>[]),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);
      await notifier.loadInitial();
      notifier.setCategory('x');
      expect(notifier.selectedCategory, 'x');

      notifier.clearCategory();

      expect(notifier.selectedCategory, isNull);
    });

    test('retry calls loadInitial again', () async {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Left(Failure(message: 'fail')),
        getCategoriesResult: const Right(<String>[]),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);
      await notifier.loadInitial();
      expect(notifier.state, isA<ProductListError>());

      repo.getProductsResult = const Right(
        ProductListResponse(
          products: <Product>[Product(id: '1', title: 'R', price: 1)],
          total: 1,
          skip: 0,
          limit: 20,
        ),
      );
      await notifier.retry();

      expect(notifier.state, isA<ProductListLoaded>());
      expect(notifier.products, hasLength(1));
    });

    test('saveScrollOffset and clearScrollOffset update savedScrollOffset', () {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Right(
          ProductListResponse(
            products: <Product>[],
            total: 0,
            skip: 0,
            limit: 20,
          ),
        ),
        getCategoriesResult: const Right(<String>[]),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);

      expect(notifier.savedScrollOffset, 0);

      notifier.saveScrollOffset(150);
      expect(notifier.savedScrollOffset, 150);

      notifier.clearScrollOffset();
      expect(notifier.savedScrollOffset, 0);
    });

    test('setSearchQuery updates searchQuery (trimmed)', () {
      final FakeProductsRepo repo = FakeProductsRepo(
        getProductsResult: const Right(
          ProductListResponse(
            products: <Product>[],
            total: 0,
            skip: 0,
            limit: 20,
          ),
        ),
        getCategoriesResult: const Right(<String>[]),
      );
      final ProductsNotifier notifier = ProductsNotifier(repo: repo);

      notifier.setSearchQuery('  laptop  ');

      expect(notifier.searchQuery, 'laptop');
    });
  });
}

class FakeProductsRepo implements ProductsRepo {
  Either<Failure, ProductListResponse>? getProductsResult;
  Either<Failure, List<String>>? getCategoriesResult;
  Future<Either<Failure, ProductListResponse>> Function()? getProductsCallback;

  FakeProductsRepo({
    this.getProductsResult,
    this.getCategoriesResult,
    this.getProductsCallback,
  });

  @override
  Future<Either<Failure, ProductListResponse>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  }) async {
    if (getProductsCallback != null) return getProductsCallback!();
    return getProductsResult!;
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return getCategoriesResult!;
  }
  
  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    throw UnimplementedError('getProduct not used in notifier tests');
  }
}

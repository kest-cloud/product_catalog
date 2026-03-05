import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/core/network/failure.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/notifier/products_notifier.dart';
import 'package:product_catalog/features/products/presentation/view/catalog_page.dart';
import 'package:provider/provider.dart';

/// Performance checks: catalog builds and settles within a reasonable time.
void main() {
  group('CatalogPage performance', () {
    testWidgets('builds list of 20 items and settles within 5s', (
      tester,
    ) async {
      final ProductsRepo repo = _FakeRepo(productCount: 20);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ProductsNotifier>(
            create: (_) => ProductsNotifier(repo: repo),
            child: const CatalogPage(),
          ),
        ),
      );

      final Stopwatch stopwatch = Stopwatch()..start();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });
}

class _FakeRepo implements ProductsRepo {
  _FakeRepo({this.productCount = 20});

  final int productCount;

  @override
  Future<Either<Failure, ProductListResponse>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  }) async {
    final List<Product> list = List<Product>.generate(
      productCount,
      (int i) => Product(
        id: '${skip + i}',
        title: 'Product ${skip + i}',
        price: 9.99 + i,
      ),
    );
    return Right(
      ProductListResponse(
        products: list,
        total: productCount,
        skip: skip,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return const Right(<String>['cat1', 'cat2']);
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    throw UnimplementedError();
  }
}

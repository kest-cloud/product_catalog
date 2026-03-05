import 'package:dartz/dartz.dart';

import 'package:product_catalog/core/network/failure.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';

/// Repository interface for product catalog data.
abstract class ProductsRepo {

  Future<Either<Failure, ProductListResponse>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  });

  Future<Either<Failure, List<String>>> getCategories();

  /// Fetches a single product by id (for detail screen / deep link).
  Future<Either<Failure, Product>> getProduct(String id);
}

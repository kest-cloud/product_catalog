// ignore_for_file: public_member_api_docs

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:product_catalog/core/network/failure.dart';
import 'package:product_catalog/features/products/data/datasource/products_remote.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';

/// Implementation of [ProductsRepo] using [ProductsRemote].
class ProductsRepoImpl implements ProductsRepo {
  ProductsRepoImpl({required ProductsRemote remote}) : _remote = remote;

  final ProductsRemote _remote;

  @override
  Future<Either<Failure, ProductListResponse>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _remote.getProducts(
        skip: skip,
        limit: limit,
        query: query,
        category: category,
      );

      if (response.statusCode != 200) {
        return Left(Failure(message: 'Request failed: ${response.statusCode}'));
      }

      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        return const Left(Failure(message: 'Empty response'));
      }

      ProductListResponse parsed = ProductListResponse.fromJson(data);

      if (category != null &&
          category.trim().isNotEmpty &&
          query != null &&
          query.trim().isNotEmpty) {
        final String cat = category.trim().toLowerCase();
        final List<Product> filtered = parsed.products
            .where((Product p) => (p.category ?? '').toLowerCase() == cat)
            .toList();
        parsed = ProductListResponse(
          products: filtered,
          total: parsed.total,
          skip: parsed.skip,
          limit: parsed.limit,
        );
      }
      return Right(parsed);
    } catch (e) {
      return Left(Failure(message: 'Failed to load products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final Response<List<String>> response = await _remote.getCategories();
      if (response.statusCode != 200) {
        return Left(Failure(message: 'Request failed: ${response.statusCode}'));
      }
      final List<String>? list = response.data;
      return Right(list ?? const <String>[]);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final Response<Map<String, dynamic>> response = await _remote.getProduct(
        id,
      );
      if (response.statusCode != 200) {
        return Left(Failure(message: 'Request failed: ${response.statusCode}'));
      }
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        return const Left(Failure(message: 'Empty response'));
      }
      return Right(Product.fromJson(data));
    } catch (e) {
      return Left(Failure(message: 'Failed to load product: ${e.toString()}'));
    }
  }
}

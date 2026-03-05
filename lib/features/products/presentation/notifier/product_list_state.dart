// ignore_for_file: public_member_api_docs

import 'package:product_catalog/features/products/data/domain/entity/product.dart';

/// UI state for the product list screen.
sealed class ProductListState {
  const ProductListState();
}

/// Initial state before any load.
final class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

/// First load in progress (no items yet).
final class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

/// Loaded with items (may have more pages).
final class ProductListLoaded extends ProductListState {
  const ProductListLoaded({
    required this.products,
    required this.total,
    required this.hasMore,
  });

  final List<Product> products;
  final int total;
  final bool hasMore;
}

/// Load failed with message.
final class ProductListError extends ProductListState {
  const ProductListError(this.message);

  final String message;
}

/// Request succeeded but no items (e.g. search/filter returned empty).
final class ProductListEmpty extends ProductListState {
  const ProductListEmpty();
}

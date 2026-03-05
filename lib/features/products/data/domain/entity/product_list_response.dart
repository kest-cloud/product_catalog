import 'package:product_catalog/features/products/data/domain/entity/product.dart';

/// API response for paginated product list.
class ProductListResponse {
  const ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  /// List of products for the current page.
  final List<Product> products;

  /// Total number of products matching the request.
  final int total;

  /// Number of items skipped (pagination offset).
  final int skip;

  /// Page size (limit).
  final int limit;

  /// Whether more pages are available.
  bool get hasMore => skip + products.length < total;

  /// Creates [ProductListResponse] from API JSON; handles bad or missing data.
  factory ProductListResponse.fromJson(final Map<String, dynamic> json) {
    final dynamic productsRaw = json['products'];
    List<Product> products = const [];
    if (productsRaw is List) {
      products = productsRaw
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .where((p) => p.id.isNotEmpty)
          .toList();
    }

    final int total = _intFrom(json['total'], 0);
    final int skip = _intFrom(json['skip'], 0);
    final int limit = _intFrom(json['limit'], 20);

    return ProductListResponse(
      products: products,
      total: total < 0 ? 0 : total,
      skip: skip < 0 ? 0 : skip,
      limit: limit <= 0 ? 20 : limit,
    );
  }

  static int _intFrom(dynamic v, final int fallback) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    final parsed = int.tryParse(v?.toString() ?? '');
    return parsed ?? fallback;
  }
}

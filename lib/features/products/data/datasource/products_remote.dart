import 'package:dio/dio.dart';

/// Remote data source for products API (DummyJSON).
abstract class ProductsRemote {
  /// GET products with optional pagination, search, and category.
  Future<Response<Map<String, dynamic>>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  });

  /// GET list of category strings.
  Future<Response<List<String>>> getCategories();

  /// GET a single product by id (for detail screen / deep link).
  Future<Response<Map<String, dynamic>>> getProduct(String id);
}

/// DummyJSON implementation.
class ProductsRemoteImpl implements ProductsRemote {
  ProductsRemoteImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Response<Map<String, dynamic>>> getProducts({
    int skip = 0,
    int limit = 20,
    String? query,
    String? category,
  }) async {
    final String path;
    final Map<String, dynamic> queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };

    // When both query and category are set we use search; category filter is applied in repo.
    if (query != null && query.trim().isNotEmpty) {
      path = '/products/search';
      queryParams['q'] = query.trim();
    } else if (category != null && category.trim().isNotEmpty) {
      path = '/products/category/${Uri.encodeComponent(category.trim())}';
    } else {
      path = '/products';
    }

    final Response<Map<String, dynamic>> response = await _dio
        .get<Map<String, dynamic>>(path, queryParameters: queryParams);
    return response;
  }

  @override
  Future<Response<Map<String, dynamic>>> getProduct(String id) async {
    final String path = '/products/${Uri.encodeComponent(id)}';
    return _dio.get<Map<String, dynamic>>(path);
  }

  @override
  Future<Response<List<String>>> getCategories() async {
    final Response<dynamic> raw = await _dio.get<dynamic>(
      '/products/categories',
    );
    List<String> list = const [];
    if (raw.data is List) {
      list = (raw.data as List)
          .map(_categoryEntryToLabel)
          .where((String e) => e.isNotEmpty)
          .toList();
    }
    return Response<List<String>>(
      data: list,
      statusCode: raw.statusCode,
      requestOptions: raw.requestOptions,
    );
  }

  static String _categoryEntryToLabel(dynamic e) {
    if (e == null) return '';
    if (e is String) return e;
    if (e is Map) {
      final Object? name = e['name'];
      if (name is String && name.isNotEmpty) return name;
      final Object? slug = e['slug'];
      if (slug is String && slug.isNotEmpty) return slug;
    }
    return '';
  }
}

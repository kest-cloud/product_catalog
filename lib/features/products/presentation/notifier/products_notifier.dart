import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:product_catalog/core/network/failure.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/entity/product_list_response.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/notifier/product_list_state.dart';

/// Notifier for the product catalog list: state, pagination, search, filter, scroll.
class ProductsNotifier extends ChangeNotifier {
  ProductsNotifier({required ProductsRepo repo}) : _repo = repo;

  final ProductsRepo _repo;

  static const int _pageSize = 20;
  static const Duration _searchDebounce = Duration(milliseconds: 400);

  ProductListState _state = const ProductListInitial();
  ProductListState get state => _state;

  List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  int _total = 0;
  int get total => _total;

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _debounceTimer;
  String _debouncedQuery = '';

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  double _savedScrollOffset = 0;
  double get savedScrollOffset => _savedScrollOffset;

  List<String> _categories = [];
  List<String> get categories => List.unmodifiable(_categories);

  bool _categoriesLoaded = false;
  bool get categoriesLoaded => _categoriesLoaded;

  int _searchSkipOffset = 0;

  bool get _hasBothQueryAndCategory =>
      _debouncedQuery.isNotEmpty &&
      _selectedCategory != null &&
      _selectedCategory!.isNotEmpty;

  Future<void> loadInitial() async {
    if (_state is ProductListLoading) return;
    _state = const ProductListLoading();
    _products = [];
    _total = 0;
    _hasMore = false;
    _searchSkipOffset = 0;
    notifyListeners();

    await _loadCategoriesIfNeeded();

    final result = await _repo.getProducts(
      skip: 0,
      limit: _pageSize,
      query: _debouncedQuery.isEmpty ? null : _debouncedQuery,
      category: _selectedCategory,
    );

    result.fold(
      (Failure failure) {
        _state = ProductListError(failure.message ?? 'Something went wrong');
        notifyListeners();
      },
      (ProductListResponse data) {
        _products = data.products;
        _total = data.total;
        _hasMore = data.hasMore;
        if (_hasBothQueryAndCategory) {
          _searchSkipOffset = _pageSize;
        }
        if (_products.isEmpty) {
          _state = const ProductListEmpty();
        } else {
          _state = ProductListLoaded(
            products: _products,
            total: _total,
            hasMore: _hasMore,
          );
        }
        notifyListeners();
      },
    );
  }

  /// Loads the next page and appends to [products].
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    if (_state is! ProductListLoaded) return;

    _isLoadingMore = true;
    notifyListeners();

    final int skip = _hasBothQueryAndCategory ? _searchSkipOffset : _products.length;
    final Either<Failure, ProductListResponse> result = await _repo.getProducts(
      skip: skip,
      limit: _pageSize,
      query: _debouncedQuery.isEmpty ? null : _debouncedQuery,
      category: _selectedCategory,
    );

    _isLoadingMore = false;

    result.fold((Failure _) => notifyListeners(), (ProductListResponse data) {
      if (data.products.isEmpty) {
        _hasMore = false;
      } else {
        _products = List<Product>.from(_products)..addAll(data.products);
        _total = data.total;
        _hasMore = data.hasMore;
        if (_hasBothQueryAndCategory) {
          _searchSkipOffset += _pageSize;
        }
        _state = ProductListLoaded(
          products: _products,
          total: _total,
          hasMore: _hasMore,
        );
      }
      notifyListeners();
    });
  }

  /// Updates search query and debounces before triggering reload.
  void setSearchQuery(String query) {
    final String trimmed = query.trim();
    if (_searchQuery == trimmed) return;
    _searchQuery = trimmed;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_searchDebounce, () {
      _debouncedQuery = _searchQuery;
      loadInitial();
    });
    notifyListeners();
  }

  /// Applies search immediately (e.g. on submit); cancels any pending debounce.
  void submitSearch(String query) {
    _debounceTimer?.cancel();
    _searchQuery = query.trim();
    _debouncedQuery = _searchQuery;
    loadInitial();
  }

  /// Sets category filter and reloads from start.
  void setCategory(String? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadInitial();
  }

  /// Clears category filter and reloads.
  void clearCategory() => setCategory(null);

  /// Retry after error (reload first page).
  Future<void> retry() => loadInitial();

  /// Saves current scroll offset for preservation (e.g. when leaving screen).
  void saveScrollOffset(double offset) {
    _savedScrollOffset = offset;
    notifyListeners();
  }

  /// Clears saved scroll offset.
  void clearScrollOffset() {
    _savedScrollOffset = 0;
    notifyListeners();
  }

  Future<void> _loadCategoriesIfNeeded() async {
    if (_categoriesLoaded) return;
    final Either<Failure, List<String>> r = await _repo.getCategories();
    r.fold((Failure _) {}, (List<String> list) {
      _categories = list;
      _categoriesLoaded = true;
    });
  }
}

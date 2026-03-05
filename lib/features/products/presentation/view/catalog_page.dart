// ignore_for_file: cascade_invocations, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:product_catalog/app/router.dart';
import 'package:product_catalog/core/theme/theme_controller.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/design_system/widgets/app_button.dart';
import 'package:product_catalog/design_system/widgets/category_chip.dart';
import 'package:product_catalog/design_system/widgets/empty_state.dart';
import 'package:product_catalog/design_system/widgets/error_state.dart';
import 'package:product_catalog/design_system/widgets/pagination_loader.dart';
import 'package:product_catalog/design_system/widgets/product_card.dart' as ds;
import 'package:product_catalog/design_system/widgets/search_bar.dart' as ds;
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/presentation/notifier/product_list_state.dart';
import 'package:product_catalog/features/products/presentation/notifier/products_notifier.dart';

/// Catalog list page: search, category filter, pagination, scroll preservation.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final ProductsNotifier notifier = context.read<ProductsNotifier>();
    notifier.loadInitial();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final ProductsNotifier notifier = context.read<ProductsNotifier>();
    notifier.saveScrollOffset(_scrollController.offset);
    final double max = _scrollController.position.maxScrollExtent;
    final double current = _scrollController.offset;
    if (max > 0 && current >= max - 200) {
      notifier.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldGradientBackground(context),
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () => context.read<ThemeController>().toggle(),
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => context.push(AppRoutes.showcase),
            tooltip: 'Design system',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ds.AppSearchBar(
              hintText: 'Search products',
              onChanged: (String value) =>
                  context.read<ProductsNotifier>().setSearchQuery(value),
            ),
          ),
          Consumer<ProductsNotifier>(
            builder: (BuildContext context, ProductsNotifier notifier, _) {
              if (!notifier.categoriesLoaded || notifier.categories.isEmpty) {
                return const SizedBox.shrink();
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: <Widget>[
                    CategoryChip(
                      label: 'All',
                      selected: notifier.selectedCategory == null,
                      onSelected: (_) => notifier.clearCategory(),
                    ),
                    const SizedBox(width: 8),
                    ...notifier.categories
                        .take(12)
                        .map(
                          (String cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              label: cat,
                              selected: notifier.selectedCategory == cat,
                              onSelected: (bool selected) =>
                                  notifier.setCategory(selected ? cat : null),
                            ),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ProductsNotifier>(
              builder: (BuildContext context, ProductsNotifier notifier, _) {
                final ProductListState s = notifier.state;
                if (s is ProductListLoading && notifier.products.isEmpty) {
                  return _buildLoading();
                }
                if (s is ProductListError) {
                  return ErrorState(
                    message: s.message,
                    onRetry: notifier.retry,
                  );
                }
                if (s is ProductListEmpty) {
                  return const EmptyState(
                    title: 'No products',
                    subtitle: 'Try a different search or category.',
                  );
                }
                if (notifier.products.isEmpty) {
                  return const Center(child: Text('No items'));
                }
                return RefreshIndicator(
                  onRefresh: () => notifier.retry(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount:
                        notifier.products.length + (notifier.hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= notifier.products.length) {
                        return _buildLoadMore(notifier);
                      }
                      final Product p = notifier.products[index];
                      return _AnimatedProductTile(
                        index: index,
                        product: p,
                        onTap: () => context.push(AppRoutes.productDetailPath(p.id)),
                        toCardModel: _toCardModel,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: ds.ProductCard(
          model: ds.ProductCardModel(
            id: '',
            name: '',
            priceLabel: '',
            imageUrl: '',
            isLoading: true,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMore(ProductsNotifier notifier) {
    if (notifier.isLoadingMore) {
      return const PaginationLoader();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: AppButton(
          label: 'Load more',
          variant: AppButtonVariant.secondary,
          onPressed: notifier.loadMore,
        ),
      ),
    );
  }

  ds.ProductCardModel _toCardModel(Product p) {
    return ds.ProductCardModel(
      id: p.id,
      name: p.title,
      priceLabel: p.priceLabel,
      imageUrl: p.imageUrl.isEmpty
          ? 'https://via.placeholder.com/72'
          : p.imageUrl,
      subtitle: p.category,
      heroTag: 'product-image-${p.id}',
    );
  }
}

class _AnimatedProductTile extends StatelessWidget {
  const _AnimatedProductTile({
    required this.index,
    required this.product,
    required this.onTap,
    required this.toCardModel,
  });

  final int index;
  final Product product;
  final VoidCallback onTap;
  final ds.ProductCardModel Function(Product p) toCardModel;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index % 5) * 50),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ds.ProductCard(model: toCardModel(product), onTap: onTap),
      ),
    );
  }
}

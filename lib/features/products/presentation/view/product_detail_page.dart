// ignore_for_file: public_member_api_docs

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/design_system/widgets/error_state.dart';
import 'package:product_catalog/design_system/widgets/loading_skeleton.dart';
import 'package:product_catalog/features/products/data/domain/entity/product.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';

/// Product detail screen: image gallery, hero, price/discount, rating, stock, category.
/// Supports deep link: /products/:id
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    required this.productId,
    required this.repo,
    super.key,
  });

  final String productId;
  final ProductsRepo repo;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (widget.productId.isEmpty) {
      setState(() {
        _error = 'Invalid product';
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.repo.getProduct(widget.productId);
    if (!mounted) return;
    result.fold(
      (e) => setState(() {
        _error = e.message ?? 'Failed to load';
        _loading = false;
      }),
      (Product p) => setState(() {
        _product = p;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppTheme.scaffoldGradientBackground(context),
        appBar: AppBar(title: const Text('Product')),
        body: const _DetailSkeleton(),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppTheme.scaffoldGradientBackground(context),
        appBar: AppBar(title: const Text('Product')),
        body: ErrorState(
          message: _error!,
          onRetry: _loadProduct,
        ),
      );
    }
    final Product product = _product!;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldGradientBackground(context),
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ImageGallery(product: product),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.brandLabel.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _PriceDiscountRow(product: product),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      if (product.rating != null) _RatingRow(rating: product.rating!),
                      if (product.stock != null) _StockIndicator(stock: product.stock!),
                      if (product.category != null)
                        _CategoryBadge(category: product.category!),
                    ],
                  ),
                  if (product.description != null && product.description!.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colors.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const LoadingSkeleton(height: 280, borderRadius: 16),
          const SizedBox(height: 24),
          const LoadingSkeleton(width: 120, height: 20),
          const SizedBox(height: 8),
          const LoadingSkeleton(width: 200, height: 24),
          const SizedBox(height: 16),
          const LoadingSkeleton(width: 100, height: 28),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  const _ImageGallery({required this.product});

  final Product product;

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;
    final List<String> urls = <String>[
      if (product.thumbnail != null && product.thumbnail!.isNotEmpty)
        product.thumbnail!,
      ...product.images,
    ].where((String u) => u.isNotEmpty).toList();

    if (urls.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, size: 64),
        ),
      );
    }

    final bool hasMultiple = urls.length > 1;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) => setState(() => _currentPage = index),
            itemCount: urls.length,
            itemBuilder: (BuildContext context, int index) {
              final String url = urls[index];
              final bool isFirst = index == 0;
              final Widget image = CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, __) => const LoadingSkeleton(borderRadius: 0),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  size: 64,
                ),
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isFirst
                    ? Hero(
                        tag: 'product-image-${product.id}',
                        child: image,
                      )
                    : image,
              );
            },
          ),
        ),
        if (hasMultiple) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${_currentPage + 1} of ${urls.length}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  urls.length,
                  (int i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: i == _currentPage ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == _currentPage
                            ? colors.primary
                            : colors.onSurface.withOpacity(0.25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe to see more',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withOpacity(0.5),
                ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _PriceDiscountRow extends StatelessWidget {
  const _PriceDiscountRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    if (!product.hasValidPrice) {
      return Text(
        product.priceLabel,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface.withOpacity(0.7),
            ),
      );
    }
    final double? discount = product.discountPercentage;
    final double discountedPrice = discount != null && discount > 0
        ? product.price * (1 - discount / 100)
        : product.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          '\$${discountedPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
        ),
        if (discount != null && discount > 0) ...<Widget>[
          const SizedBox(width: 12),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colors.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '-${discount.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star_rounded,
          color: Colors.amber.shade700,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _StockIndicator extends StatelessWidget {
  const _StockIndicator({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool inStock = stock > 0;
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: inStock ? colors.secondary : colors.error,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          inStock ? 'In stock ($stock)' : 'Out of stock',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: inStock
                    ? colors.onSurface
                    : colors.error,
              ),
        ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final String label = category.isNotEmpty
        ? '${category[0].toUpperCase()}${category.substring(1)}'
        : category;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

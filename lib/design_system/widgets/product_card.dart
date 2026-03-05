import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_card.dart';
import 'package:product_catalog/design_system/widgets/app_text.dart';
import 'package:product_catalog/design_system/widgets/image_placeholder.dart';
import 'package:product_catalog/design_system/widgets/loading_skeleton.dart';

/// View model describing a product for use with [ProductCard].
class ProductCardModel {
  /// Creates a new [ProductCardModel].
  const ProductCardModel({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.imageUrl,
    this.subtitle,
    this.isLoading = false,
    this.heroTag,
  });

  /// Stable identifier for the product.
  final String id;

  /// Primary product name.
  final String name;

  /// Human readable price label (e.g. "$199").
  final String priceLabel;

  /// Optional secondary text (e.g. category).
  final String? subtitle;

  /// Remote image URL.
  final String imageUrl;

  /// Whether the card is in loading state.
  final bool isLoading;

  /// Optional [Hero] tag for the image (e.g. 'product-image-$id' for detail transition).
  final String? heroTag;
}

/// Reusable card for displaying product information.
class ProductCard extends StatelessWidget {
  /// Creates a new [ProductCard].
  const ProductCard({required this.model, super.key, this.onTap});

  /// Backing view model.
  final ProductCardModel model;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: model.isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(24),
      child: AppCard(
        child: Row(
          children: <Widget>[
            if (model.isLoading)
              const SizedBox.square(
                dimension: 72,
                child: LoadingSkeleton(borderRadius: 16),
              )
            else
              SizedBox.square(
                dimension: 72,
                child: model.heroTag != null
                    ? Hero(
                        tag: model.heroTag!,
                        child: ImagePlaceholder(
                          imageUrl: model.imageUrl,
                          borderRadius: 16,
                        ),
                      )
                    : ImagePlaceholder(
                        imageUrl: model.imageUrl,
                        borderRadius: 16,
                      ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (model.isLoading) ...<Widget>[
                    const LoadingSkeleton(width: 140, height: 14),
                    const SizedBox(height: 8),
                    const LoadingSkeleton(width: 80, height: 12),
                  ] else ...<Widget>[
                    Text(
                      model.name,
                      style: AppText.body(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (model.subtitle != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        model.subtitle!,
                        style: AppText.muted(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      model.priceLabel,
                      style: AppText.body(context).copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.w600,
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

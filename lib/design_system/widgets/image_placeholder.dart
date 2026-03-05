import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/loading_skeleton.dart';

/// Wrapper around [CachedNetworkImage] that provides consistent
/// placeholders and error handling.
class ImagePlaceholder extends StatelessWidget {
  /// Creates a new [ImagePlaceholder].
  const ImagePlaceholder({
    required this.imageUrl,
    super.key,
    this.borderRadius = 16,
    this.aspectRatio = 1,
  });

  /// Remote image URL.
  final String imageUrl;

  /// Corner radius for clipping.
  final double borderRadius;

  /// Aspect ratio for the image box.
  final double aspectRatio;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (final BuildContext context, final String _) =>
              const LoadingSkeleton(),
          errorWidget:
              (final BuildContext context, final String _, final Object __) =>
                  Container(
                    color: colors.surfaceVariant,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
        ),
      ),
    );
  }
}

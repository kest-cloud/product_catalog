// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:product_catalog/core/theme/app_theme.dart';

/// Card elevation variants.
enum AppCardVariant {
  /// Glass-like surface with soft shadow.
  elevated,

  /// Subtle outline-only card.
  outline,

  /// Flat card without extra styling.
  flat,
}

/// Reusable surface for grouping related content.
class AppCard extends StatelessWidget {
  /// Creates a new [AppCard].
  const AppCard({
    required this.child,
    super.key,
    this.variant = AppCardVariant.elevated,
    this.padding = const EdgeInsets.all(16),
  });

  /// Child widget to render inside the card.
  final Widget child;

  /// Card visual variant.
  final AppCardVariant variant;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(final BuildContext context) {
    final Widget content = Padding(padding: padding, child: child);

    switch (variant) {
      case AppCardVariant.elevated:
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: AppTheme.glassBlur(),
            child: DecoratedBox(
              decoration: AppTheme.glassCardDecoration(context),
              child: content,
            ),
          ),
        );
      case AppCardVariant.outline:
        final ColorScheme colors = Theme.of(context).colorScheme;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.outline.withOpacity(0.6)),
          ),
          child: content,
        );
      case AppCardVariant.flat:
        return Card(elevation: 0, child: content);
    }
  }
}

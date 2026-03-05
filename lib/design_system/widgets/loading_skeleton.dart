import 'package:flutter/material.dart';

/// Simple loading skeleton block for shimmering placeholders.
class LoadingSkeleton extends StatelessWidget {
  /// Creates a new [LoadingSkeleton].
  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 12,
    this.borderRadius = 8,
  });

  /// Optional width, defaults to expanding.
  final double? width;

  /// Height of the skeleton.
  final double height;

  /// Corner radius.
  final double borderRadius;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colors.surfaceVariant.withOpacity(0.6),
      ),
    );
  }
}


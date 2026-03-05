import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_button.dart';
import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Shared error state widget for failed loads.
class ErrorState extends StatelessWidget {
  /// Creates a new [ErrorState].
  const ErrorState({
    required this.message,
    required this.onRetry,
    super.key,
    this.icon,
  });

  /// Message describing the error.
  final String message;

  /// Callback for retry action.
  final VoidCallback onRetry;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon ?? Icons.error_outline,
              size: 40,
              color: colors.error,
            ),
            const SizedBox(height: 12),
            AppBodyText(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Retry',
              variant: AppButtonVariant.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}


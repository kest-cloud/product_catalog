import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Visual variants for [AppButton].
enum AppButtonVariant {
  /// High-emphasis button.
  primary,

  /// Outline-style button.
  secondary,

  /// Low-emphasis, text-only button.
  ghost,
}

/// Reusable button with consistent styling and variants.
class AppButton extends StatelessWidget {
  /// Creates a new [AppButton].
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
    this.isLoading = false,
    this.leadingIcon,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Visual variant.
  final AppButtonVariant variant;

  /// Whether the button should expand to full width.
  final bool fullWidth;

  /// When true, replaces content with a small progress indicator.
  final bool isLoading;

  /// Optional leading icon.
  final IconData? leadingIcon;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool enabled = onPressed != null && !isLoading;

    ButtonStyle baseStyle;
    switch (variant) {
      case AppButtonVariant.primary:
        baseStyle = ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        );
      case AppButtonVariant.secondary:
        baseStyle = OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        );
      case AppButtonVariant.ghost:
        baseStyle = TextButton.styleFrom(
          foregroundColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        );
    }

    Widget child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _progressColorForVariant(colors),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (leadingIcon != null) ...<Widget>[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: 8),
              ],
              AppBodyText(label),
            ],
          );

    if (fullWidth) {
      child = SizedBox(
        width: double.infinity,
        child: Center(child: child),
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: baseStyle,
          child: child,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: baseStyle,
          child: child,
        );
      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: enabled ? onPressed : null,
          style: baseStyle,
          child: child,
        );
    }
  }

  Color _progressColorForVariant(final ColorScheme colors) {
    switch (variant) {
      case AppButtonVariant.primary:
        return colors.onPrimary;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return colors.primary;
    }
  }
}

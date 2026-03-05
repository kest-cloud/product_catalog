import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_button.dart';
import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Shared empty state for when there is no content to display.
class EmptyState extends StatelessWidget {
  /// Creates a new [EmptyState].
  const EmptyState({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
    this.ctaLabel,
    this.onCtaTap,
  });

  /// Main title text.
  final String title;

  /// Supporting subtitle text.
  final String subtitle;

  /// Optional illustrative icon.
  final IconData? icon;

  /// Optional call-to-action label.
  final String? ctaLabel;

  /// Optional call-to-action callback.
  final VoidCallback? onCtaTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.9, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double value, Widget? child) {
          // Curve can overshoot (e.g. easeOutBack) or produce NaN on rapid rebuilds
          final double safeOpacity = value.isNaN ? 1.0 : value.clamp(0.0, 1.0);
          final double safeScale = value.isNaN ? 1.0 : value.clamp(0.0, 2.0);
          return Opacity(
            opacity: safeOpacity,
            child: Transform.scale(scale: safeScale, child: child),
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                colors.primary.withOpacity(0.10),
                colors.secondaryContainer.withOpacity(0.14),
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.primary.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer.withOpacity(0.7),
                ),
                child: Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 30,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),
              AppDisplayText(title),
              const SizedBox(height: 8),
              AppBodyText(subtitle, textAlign: TextAlign.center),
              if (ctaLabel != null && onCtaTap != null) ...<Widget>[
                const SizedBox(height: 20),
                AppButton(
                  label: ctaLabel!,
                  variant: AppButtonVariant.primary,
                  onPressed: onCtaTap!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

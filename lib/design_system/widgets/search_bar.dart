import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Reusable pill-shaped search field.
class AppSearchBar extends StatelessWidget {
  /// Creates a new [AppSearchBar].
  const AppSearchBar({
    required this.hintText,
    required this.onChanged,
    super.key,
    this.controller,
  });

  /// Hint text to show when empty.
  final String hintText;

  /// Optional text controller.
  final TextEditingController? controller;

  /// Called whenever the query changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        hintStyle: AppText.muted(context),
        filled: true,
        fillColor: colors.surface.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}

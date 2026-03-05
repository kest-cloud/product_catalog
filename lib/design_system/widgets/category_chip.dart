import 'package:flutter/material.dart';

import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Selectable pill-style chip for categories or filters.
class CategoryChip extends StatelessWidget {
  /// Creates a new [CategoryChip].
  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Text label for the chip.
  final String label;

  /// Whether the chip is currently selected.
  final bool selected;

  /// Selection callback.
  final ValueChanged<bool> onSelected;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final Color background = selected
        ? colors.primary.withOpacity(0.12)
        : colors.surface.withOpacity(0.9);
    final Color borderColor =
        selected ? colors.primary : colors.outline.withOpacity(0.6);
    final Color textColor =
        selected ? colors.primary : colors.onSurface.withOpacity(0.8);

    return ChoiceChip(
      label: Text(
        label,
        style: AppText.body(context).copyWith(
          color: textColor,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      backgroundColor: background,
      selectedColor: background,
      shape: StadiumBorder(
        side: BorderSide(color: borderColor),
      ),
    );
  }
}


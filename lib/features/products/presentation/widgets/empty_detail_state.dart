import 'package:flutter/material.dart';

import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/design_system/widgets/app_text.dart';

/// Placeholder shown in the detail pane when no product is selected (tablet).
class EmptyDetailState extends StatelessWidget {
  const EmptyDetailState({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.scaffoldGradientBackground(context),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.touch_app_outlined,
              size: 64,
              color: colors.outline.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            const AppDisplayText(
              'Select a product',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: AppBodyText(
                'Choose an item from the list to view details.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

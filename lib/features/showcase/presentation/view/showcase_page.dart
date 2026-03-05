// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/theme_controller.dart';
import 'package:product_catalog/design_system/widgets/app_button.dart';
import 'package:product_catalog/design_system/widgets/app_card.dart';
import 'package:product_catalog/design_system/widgets/app_text.dart';
import 'package:product_catalog/design_system/widgets/category_chip.dart';
import 'package:product_catalog/design_system/widgets/empty_state.dart';
import 'package:product_catalog/design_system/widgets/error_state.dart';
import 'package:product_catalog/design_system/widgets/loading_skeleton.dart';
import 'package:product_catalog/design_system/widgets/pagination_loader.dart';
import 'package:product_catalog/design_system/widgets/product_card.dart' as ds;
import 'package:product_catalog/design_system/widgets/search_bar.dart' as ds;
import 'package:provider/provider.dart';

/// Showcase of design system components. Used for demos and QA.
class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeController>().toggle(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const _Section(
            title: 'Typography',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppDisplayText('Display headline'),
                SizedBox(height: 8),
                AppBodyText('Body text with readable line height.'),
              ],
            ),
          ),
          _Section(
            title: 'Buttons',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                AppButton(
                  label: 'Primary',
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Secondary',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          _Section(
            title: 'Search bar',
            child: ds.AppSearchBar(hintText: 'Search…', onChanged: (_) {}),
          ),
          _Section(
            title: 'Category chips',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  CategoryChip(
                    label: 'All',
                    selected: true,
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Electronics',
                    selected: false,
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Groceries',
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
          ),
          _Section(
            title: 'Cards',
            child: Column(
              children: <Widget>[
                const AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: AppBodyText('AppCard with content'),
                  ),
                ),
                const SizedBox(height: 12),
                ds.ProductCard(
                  model: const ds.ProductCardModel(
                    id: '1',
                    name: 'Sample Product',
                    priceLabel: '\$29.99',
                    imageUrl: 'https://via.placeholder.com/72',
                    subtitle: 'Category',
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          _Section(
            title: 'Loading & states',
            child: Column(
              children: <Widget>[
                const LoadingSkeleton(width: 200, height: 24),
                const SizedBox(height: 16),
                const PaginationLoader(),
                const SizedBox(height: 16),
                EmptyState(
                  title: 'No items',
                  subtitle: 'Nothing to show here.',
                  ctaLabel: 'Retry',
                  onCtaTap: () {},
                ),
                const SizedBox(height: 16),
                ErrorState(message: 'Something went wrong', onRetry: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

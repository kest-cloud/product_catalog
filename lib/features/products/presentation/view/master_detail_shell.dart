// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/layout/breakpoints.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/view/catalog_page.dart';
import 'package:product_catalog/features/products/presentation/view/product_detail_page.dart';
import 'package:product_catalog/features/products/presentation/widgets/empty_detail_state.dart';

/// Responsive shell: tablet = split view (list + detail), phone = single pane.
/// State is synced via route: /products/:id.
class MasterDetailShell extends StatelessWidget {
  const MasterDetailShell({
    required this.state,
    required this.productsRepo,
    super.key,
  });

  final GoRouterState state;
  final ProductsRepo productsRepo;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
  }

  /// Extracts product id from current route (e.g. /products/123 -> 123).
  static String? selectedProductId(GoRouterState state) {
    return selectedProductIdFromPath(state.uri.path, state.pathParameters);
  }

  /// Parses product id from path and pathParams; testable without [GoRouterState].
  static String? selectedProductIdFromPath(
    String path,
    Map<String, String> pathParameters,
  ) {
    if (path.startsWith('/products/') && path.length > '/products/'.length) {
      return path.substring('/products/'.length).split('/').first;
    }
    return pathParameters['id'];
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);
    final String? selectedId = selectedProductId(state);

    if (tablet) {
      return Row(
        children: <Widget>[
          const Expanded(flex: 1, child: CatalogPage()),
          Expanded(
            flex: 1,
            child: selectedId != null && selectedId.isNotEmpty
                ? ProductDetailPage(productId: selectedId, repo: productsRepo)
                : const EmptyDetailState(),
          ),
        ],
      );
    }

    // Phone: single pane from nested route
    if (selectedId != null && selectedId.isNotEmpty) {
      return ProductDetailPage(productId: selectedId, repo: productsRepo);
    }
    return const CatalogPage();
  }
}

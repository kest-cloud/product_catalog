// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/layout/breakpoints.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/view/catalog_page.dart';
import 'package:product_catalog/features/products/presentation/widgets/empty_detail_state.dart';

/// Responsive shell: tablet = split view (list + empty detail pane), phone = list only.
/// Product detail is pushed as a top-level route so Hero transition works from list to detail.
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
  /// Used for tests and any future shell-based detail (e.g. tablet split).
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

    if (tablet) {
      return Row(
        children: <Widget>[
          const Expanded(flex: 1, child: CatalogPage()),
          const Expanded(flex: 1, child: EmptyDetailState()),
        ],
      );
    }

    return const CatalogPage();
  }
}

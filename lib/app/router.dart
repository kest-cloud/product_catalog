// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';
import 'package:product_catalog/features/products/presentation/notifier/products_notifier.dart';
import 'package:product_catalog/features/products/presentation/view/master_detail_shell.dart';
import 'package:product_catalog/features/products/presentation/view/product_detail_page.dart';
import 'package:product_catalog/features/showcase/presentation/view/showcase_page.dart';
import 'package:provider/provider.dart';

/// Route names and paths used across the app.
abstract final class AppRoutes {
  static const String home = '/';
  static const String productDetail = 'productDetail';
  static const String showcase = '/showcase';
  static String productDetailPath(String id) => '/products/$id';
}

/// Global [GoRouter] configuration. [productsRepo] is passed in to avoid circular DI.
GoRouter createRouter(ProductsRepo productsRepo) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ChangeNotifierProvider<ProductsNotifier>(
            create: (_) => ProductsNotifier(repo: productsRepo)..loadInitial(),
            child: MasterDetailShell(state: state, productsRepo: productsRepo),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                transitionsBuilder:
                    (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                        reverseCurve: Curves.easeInCubic,
                      );
                      return FadeTransition(opacity: curved, child: child);
                    },
                child: const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/products/:id',
        name: AppRoutes.productDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['id'] ?? '';
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionsBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  return FadeTransition(opacity: curved, child: child);
                },
            child: ProductDetailPage(productId: id, repo: productsRepo),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.showcase,
        name: 'showcase',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionsBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  return FadeTransition(opacity: curved, child: child);
                },
            child: const ShowcasePage(),
          );
        },
      ),
    ],
  );
}

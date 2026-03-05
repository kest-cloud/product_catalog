// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:product_catalog/core/di/app_providers.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/theme/theme_controller.dart';
import 'package:provider/provider.dart';

/// Root widget for the Product Catalog application.
class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final router = getItRouter;

    return ChangeNotifierProvider<ThemeController>(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (
          final BuildContext context,
          final ThemeController themeController,
          final Widget? child,
        ) {
          final bool useDark = themeController.mode == ThemeMode.dark ||
              (themeController.mode == ThemeMode.system &&
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark);
          final ThemeData themeData =
              useDark ? AppTheme.dark() : AppTheme.light();
          return AnimatedTheme(
            data: themeData,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: MaterialApp.router(
              title: 'Product Catalog',
              debugShowCheckedModeBanner: false,
              theme: themeData,
              darkTheme: themeData,
              themeMode: ThemeMode.light,
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}

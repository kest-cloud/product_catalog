import 'package:flutter/material.dart';

import 'package:product_catalog/app/app.dart';
import 'package:product_catalog/core/di/app_providers.dart';

/// Entry point for the Product Catalog app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(const ProductCatalogApp());
}

// ignore_for_file: cascade_invocations

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:product_catalog/app/router.dart';
import 'package:product_catalog/core/env/env.dart';
import 'package:product_catalog/features/products/data/datasource/products_remote.dart';
import 'package:product_catalog/features/products/data/datasource/repository/products_repo_impl.dart';
import 'package:product_catalog/features/products/data/domain/repository/products_repo.dart';

/// Global service locator instance.
final GetIt getIt = GetIt.instance;

/// Configures and registers all application-wide dependencies.
Future<void> setupLocator() async {
  _registerHttpClient();
  _registerProducts();
  _registerRouter();
}

/// Convenient getter for the global [GoRouter].
GoRouter get getItRouter => getIt<GoRouter>();

void _registerRouter() {
  getIt.registerLazySingleton<GoRouter>(
    () => createRouter(getIt<ProductsRepo>()),
  );
}

void _registerHttpClient() {
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  final BaseOptions options = BaseOptions(
    baseUrl: Env.baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  );

  final Dio dio = Dio(options)
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        requestHeader: false,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );

  getIt.registerLazySingleton<Dio>(() => dio);
}

void _registerProducts() {
  if (getIt.isRegistered<ProductsRepo>()) return;
  getIt.registerLazySingleton<ProductsRemote>(
    () => ProductsRemoteImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImpl(remote: getIt<ProductsRemote>()),
  );
}

import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/features/products/presentation/view/master_detail_shell.dart';

void main() {
  group('MasterDetailShell.selectedProductIdFromPath', () {
    test('returns id from path /products/123', () {
      expect(
        MasterDetailShell.selectedProductIdFromPath(
          '/products/123',
          <String, String>{},
        ),
        '123',
      );
    });

    test('returns id from path with trailing content', () {
      expect(
        MasterDetailShell.selectedProductIdFromPath(
          '/products/456/',
          <String, String>{},
        ),
        '456',
      );
    });

    test('returns null for root path', () {
      expect(
        MasterDetailShell.selectedProductIdFromPath('/', <String, String>{}),
        isNull,
      );
    });

    test('returns id from pathParameters when path has no id', () {
      expect(
        MasterDetailShell.selectedProductIdFromPath(
          '/',
          <String, String>{'id': '99'},
        ),
        '99',
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:product_catalog/core/layout/breakpoints.dart';

void main() {
  group('Breakpoints', () {
    test('tablet is 768', () {
      expect(Breakpoints.tablet, 768);
    });
  });
}

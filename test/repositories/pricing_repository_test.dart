import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('returns correct per-item prices for footlong and six-inch', () {
      final repo = PricingRepository(); // defaults: 11.0 / 7.0
      expect(repo.perItemPrice(isFootlong: true), equals(11.0));
      expect(repo.perItemPrice(isFootlong: false), equals(7.0));
    });

    test('calculates total price and returns 0.0 for non-positive quantities', () {
      final repo = PricingRepository();
      expect(repo.totalPrice(quantity: 3, isFootlong: true), equals(33.0)); // 11 * 3
      expect(repo.totalPrice(quantity: 2, isFootlong: false), equals(14.0)); // 7 * 2
      expect(repo.totalPrice(quantity: 0, isFootlong: true), equals(0.0));
      expect(repo.totalPrice(quantity: -1, isFootlong: false), equals(0.0));
    });

    test('formatPrice produces pound string and copyWith updates prices', () {
      final repo = PricingRepository();
      final custom = repo.copyWith(footlongPrice: 12.5, sixInchPrice: 8.0);
      expect(custom.perItemPrice(isFootlong: true), equals(12.5));
      expect(custom.perItemPrice(isFootlong: false), equals(8.0));
      final total = custom.totalPrice(quantity: 2, isFootlong: true); // 25.0
      expect(custom.formatPrice(total), equals('£25.00'));
    });
  });
}
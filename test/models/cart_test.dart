import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    test('merges identical sandwiches by increasing quantity', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      cart.add(s, quantity: 2);
      cart.add(s, quantity: 3);

      expect(
        cart.items.length,
        equals(1),
        reason: 'Identical sandwiches should merge',
      );
      expect(cart.totalQuantity(), equals(5));
    });

    test('calculates total price and updates when removing one', () {
      final cart = Cart();
      final footlong = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      final sixInch = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(footlong, quantity: 2); // 2 * £11 = £22
      cart.add(sixInch, quantity: 1); // 1 * £7  = £7
      expect(cart.totalQuantity(), equals(3));
      expect(cart.totalPrice(), equals(29.0));
      expect(cart.totalPriceFormatted(), equals('£29.00'));

      // remove one footlong
      cart.removeOne(footlong);
      expect(cart.totalQuantity(), equals(2));
      expect(cart.totalPrice(), equals(18.0)); // 1*11 + 1*7 = 18
      expect(cart.totalPriceFormatted(), equals('£18.00'));

      // remove the six-inch entry completely
      cart.remove(sixInch);
      expect(cart.items.length, equals(1));
      expect(cart.totalQuantity(), equals(1));
      expect(cart.totalPrice(), equals(11.0));
    });
  });
}

/*
Example usage:

import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';

final cart = Cart();
final s = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.wheat);
cart.add(s, quantity: 2);
print(cart.totalPriceFormatted()); // e.g. "£22.00"
*/

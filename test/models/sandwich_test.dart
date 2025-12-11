import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('can be created and exposes fields', () {
      const sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      expect(sandwich.type, SandwichType.tunaMelt);
      expect(sandwich.isFootlong, isTrue);
      expect(sandwich.breadType, BreadType.wheat);
      expect(sandwich.name, 'Tuna Melt');
      expect(sandwich.image, contains('tunaMelt'));
    });

    test('equality and hashCode work for map keys', () {
      const a = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );
      const b = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(a, equals(b));
      final map = {a: 1};
      expect(map[b], 1);
    });
  });
}

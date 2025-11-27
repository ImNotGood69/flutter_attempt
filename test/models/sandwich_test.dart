import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sandwich model', () {
    test('can be created and exposes fields', () {
      final sandwich = Sandwich(
        quantity: 3,
        size: 'footlong',
        bread: 'wheat',
        isToasted: true,
        note: 'no onions',
      );

      expect(sandwich.quantity, equals(3));
      expect(sandwich.size, equals('footlong'));
      expect(sandwich.bread, equals('wheat'));
      expect(sandwich.isToasted, isTrue);
      expect(sandwich.note, equals('no onions'));
    });

    test('serializes to and from JSON', () {
      final sandwich = Sandwich(
        quantity: 2,
        size: 'six-inch',
        bread: 'white',
        isToasted: false,
        note: 'extra mayo',
      );

      final json = sandwich.toJson();
      // basic sanity checks on JSON shape
      expect(json['quantity'], equals(2));
      expect(json['size'], equals('six-inch'));
      expect(json['bread'], equals('white'));
      expect(json['isToasted'], equals(false));
      expect(json['note'], equals('extra mayo'));

      final fromJson = Sandwich.fromJson(json);
      expect(fromJson.quantity, equals(sandwich.quantity));
      expect(fromJson.size, equals(sandwich.size));
      expect(fromJson.bread, equals(sandwich.bread));
      expect(fromJson.isToasted, equals(sandwich.isToasted));
      expect(fromJson.note, equals(sandwich.note));
    });

    test('copyWith returns a modified copy and does not mutate original', () {
      final original = Sandwich(
        quantity: 1,
        size: 'six-inch',
        bread: 'wholemeal',
        isToasted: false,
        note: '',
      );

      final modified = original.copyWith(quantity: 4, isToasted: true);

      // original unchanged
      expect(original.quantity, equals(1));
      expect(original.isToasted, isFalse);

      // modified values applied
      expect(modified.quantity, equals(4));
      expect(modified.isToasted, isTrue);

      // other fields preserved
      expect(modified.size, equals(original.size));
      expect(modified.bread, equals(original.bread));
      expect(modified.note, equals(original.note));
    });
  });
}

class Sandwich {
  final int quantity;
  final String size; // 'footlong' or 'six-inch'
  final String bread; // e.g. 'wheat', 'white', 'wholemeal'
  final bool isToasted;
  final String note;

  const Sandwich({
    required this.quantity,
    required this.size,
    required this.bread,
    this.isToasted = false,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'size': size,
      'bread': bread,
      'isToasted': isToasted,
      'note': note,
    };
  }

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    return Sandwich(
      quantity: json['quantity'] as int? ?? 0,
      size: json['size'] as String? ?? 'six-inch',
      bread: json['bread'] as String? ?? 'white',
      isToasted: json['isToasted'] as bool? ?? false,
      note: json['note'] as String? ?? '',
    );
  }

  Sandwich copyWith({
    int? quantity,
    String? size,
    String? bread,
    bool? isToasted,
    String? note,
  }) {
    return Sandwich(
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      bread: bread ?? this.bread,
      isToasted: isToasted ?? this.isToasted,
      note: note ?? this.note,
    );
  }
}

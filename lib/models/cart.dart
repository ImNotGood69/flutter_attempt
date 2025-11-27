import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Represents one entry in the cart: a Sandwich and its quantity.
class CartItem {
  final Sandwich sandwich;
  final int quantity;

  const CartItem(this.sandwich, this.quantity);

  CartItem copyWith({Sandwich? sandwich, int? quantity}) {
    return CartItem(sandwich ?? this.sandwich, quantity ?? this.quantity);
  }

  Map<String, dynamic> toJson() => {
    'sandwich': {
      'type': sandwich.type.name,
      'isFootlong': sandwich.isFootlong,
      'breadType': sandwich.breadType.name,
    },
    'quantity': quantity,
  };

  static CartItem fromJson(Map<String, dynamic> json) {
    final s = json['sandwich'] as Map<String, dynamic>;
    final typeName = s['type'] as String;
    final breadName = s['breadType'] as String;
    final isFootlong = s['isFootlong'] as bool? ?? false;

    final sandwichType = SandwichType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => SandwichType.veggieDelight,
    );
    final breadType = BreadType.values.firstWhere(
      (e) => e.name == breadName,
      orElse: () => BreadType.white,
    );

    final sandwich = Sandwich(
      type: sandwichType,
      isFootlong: isFootlong,
      breadType: breadType,
    );

    return CartItem(sandwich, (json['quantity'] as int?) ?? 1);
  }
}

/// Simple shopping cart holding multiple Sandwich items with quantities.
/// PricingRepository is injectable for testability.
class Cart {
  final PricingRepository pricingRepository;
  final List<CartItem> _entries = [];

  Cart({PricingRepository? pricingRepository})
    : pricingRepository = pricingRepository ?? PricingRepository();

  /// Read-only view of cart items (Sandwich + quantity).
  List<CartItem> get items => List.unmodifiable(_entries);

  /// Adds one or merges with an existing equivalent sandwich entry.
  /// Sandwich instances are not mutated; quantities are tracked in CartItem.
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final idx = _indexOfEquivalent(sandwich);
    if (idx >= 0) {
      final e = _entries[idx];
      _entries[idx] = e.copyWith(quantity: e.quantity + quantity);
    } else {
      _entries.add(CartItem(sandwich, quantity));
    }
  }

  /// Removes the entire entry that matches [sandwich].
  void remove(Sandwich sandwich) {
    final idx = _indexOfEquivalent(sandwich);
    if (idx >= 0) _entries.removeAt(idx);
  }

  /// Decreases quantity of a matching entry by one. Removes entry if quantity reaches 0.
  void removeOne(Sandwich sandwich) {
    final idx = _indexOfEquivalent(sandwich);
    if (idx < 0) return;
    final e = _entries[idx];
    if (e.quantity <= 1) {
      _entries.removeAt(idx);
    } else {
      _entries[idx] = e.copyWith(quantity: e.quantity - 1);
    }
  }

  /// Clears the cart.
  void clear() => _entries.clear();

  /// Total number of sandwiches (sum of quantities).
  int totalQuantity() => _entries.fold(0, (sum, e) => sum + e.quantity);

  /// Total price using the injected PricingRepository.
  double totalPrice() {
    double total = 0.0;
    for (final e in _entries) {
      total += pricingRepository.totalPrice(
        quantity: e.quantity,
        isFootlong: e.sandwich.isFootlong,
      );
    }
    return total;
  }

  /// Formatted total price using PricingRepository.formatPrice.
  String totalPriceFormatted() => pricingRepository.formatPrice(totalPrice());

  /// Serializes the cart and its items to JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'items': _entries.map((e) => e.toJson()).toList(),
  };

  /// Deserializes a Cart from JSON-compatible map.
  static Cart fromJson(
    Map<String, dynamic> json, {
    PricingRepository? pricingRepository,
  }) {
    final cart = Cart(pricingRepository: pricingRepository);
    final items = (json['items'] as List<dynamic>?) ?? [];
    for (final it in items) {
      if (it is Map<String, dynamic>) {
        cart._entries.add(CartItem.fromJson(it));
      }
    }
    return cart;
  }

  // Helper: find index of an equivalent sandwich in entries.
  int _indexOfEquivalent(Sandwich s) {
    for (var i = 0; i < _entries.length; i++) {
      if (_areEquivalent(_entries[i].sandwich, s)) return i;
    }
    return -1;
  }

  // Define equivalence by identifying fields on Sandwich.
  bool _areEquivalent(Sandwich a, Sandwich b) {
    return a.type == b.type &&
        a.isFootlong == b.isFootlong &&
        a.breadType == b.breadType;
  }
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

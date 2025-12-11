import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};
  final PricingRepository _pricingRepository;

  Cart({PricingRepository? pricingRepository})
    : _pricingRepository = pricingRepository ?? PricingRepository();

  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    _items[sandwich] = (_items[sandwich] ?? 0) + quantity;
    notifyListeners();
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final current = _items[sandwich];
    if (current == null) return;
    if (current > quantity) {
      _items[sandwich] = current - quantity;
    } else {
      _items.remove(sandwich);
    }
    notifyListeners();
  }

  void removeOne(Sandwich sandwich) => remove(sandwich, quantity: 1);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int totalQuantity() => _items.values.fold(0, (sum, q) => sum + q);

  double totalPrice() {
    double total = 0;
    _items.forEach((sandwich, qty) {
      total += _pricingRepository.totalPrice(
        quantity: qty,
        isFootlong: sandwich.isFootlong,
      );
    });
    return total;
  }

  String totalPriceFormatted() => _pricingRepository.formatPrice(totalPrice());

  bool get isEmpty => _items.isEmpty;
  int get length => _items.length;

  int getQuantity(Sandwich sandwich) => _items[sandwich] ?? 0;
}

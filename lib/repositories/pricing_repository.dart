/// Simple pricing repository for sandwich orders.
///
/// Usage:
/// final repo = PricingRepository(); // uses defaults
/// final total = repo.totalPrice(quantity: 3, isFootlong: true);
class PricingRepository {
  final double _footlongPrice;
  final double _sixInchPrice;

  /// Create with optional custom prices (defaults in GBP).
  PricingRepository({double footlongPrice = 11.0, double sixInchPrice = 7.0})
    : _footlongPrice = footlongPrice,
      _sixInchPrice = sixInchPrice;

  /// Returns the per-item price for the chosen size.
  double perItemPrice({required bool isFootlong}) =>
      isFootlong ? _footlongPrice : _sixInchPrice;

  /// Calculates the total price for [quantity] items of the given size.
  /// Returns 0.0 for non-positive quantities.
  double totalPrice({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    return perItemPrice(isFootlong: isFootlong) * quantity;
  }

  /// Formats a price as a string with two decimals and a pound sign.
  String formatPrice(double price) => '£${price.toStringAsFixed(2)}';

  /// Returns a copy with updated prices.
  PricingRepository copyWith({double? footlongPrice, double? sixInchPrice}) {
    return PricingRepository(
      footlongPrice: footlongPrice ?? _footlongPrice,
      sixInchPrice: sixInchPrice ?? _sixInchPrice,
    );
  }

  /// Compatibility helper matching older call sites.
  double calculatePrice({required int quantity, required bool isFootlong}) {
    return totalPrice(quantity: quantity, isFootlong: isFootlong);
  }
}

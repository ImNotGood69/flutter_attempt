import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Map<String, Object> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice(),
      'itemCount': cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Checkout'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            final children = <Widget>[
              Text('Order Summary', style: heading2),
              const SizedBox(height: 20),
            ];

            for (final entry in cart.items.entries) {
              final Sandwich sandwich = entry.key;
              final int quantity = entry.value;
              final double itemPrice = _calculateItemPrice(sandwich, quantity);

              children.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${quantity}x ${sandwich.name}', style: normalText),
                    Text('£${itemPrice.toStringAsFixed(2)}', style: normalText),
                  ],
                ),
              );
              children.add(const SizedBox(height: 8));
            }

            children.addAll(const [Divider(), SizedBox(height: 10)]);

            children.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: heading2),
                  Text(
                    '£${cart.totalPrice().toStringAsFixed(2)}',
                    style: heading2,
                  ),
                ],
              ),
            );

            children.addAll([
              const SizedBox(height: 40),
              Text(
                'Payment Method: Card ending in 1234',
                style: normalText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ]);

            if (_isProcessing) {
              children.addAll([
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                Text(
                  'Processing payment...',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
              ]);
            } else {
              children.add(
                ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Confirm Payment', style: normalText),
                ),
              );
            }

            return Column(children: children);
          },
        ),
      ),
    );
  }
}

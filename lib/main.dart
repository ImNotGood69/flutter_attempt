import 'package:sandwich_shop/views/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

enum BreadType { white, wheat, wholemeal }

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  late final OrderRepository _orderRepository;
  late final PricingRepository _pricingRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  bool _isToasted = false;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _pricingRepository = PricingRepository(); // footlong=11, sixInch=7
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_quantity < widget.maxQuantity) {
      return () {
        setState(() => _quantity++);
      };
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return () {
        setState(() => _quantity--);
      };
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) setState(() => _selectedBreadType = value);
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    return BreadType.values
        .map((b) => DropdownMenuEntry<BreadType>(value: b, label: b.name))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sandwichType = _isFootlong ? 'footlong' : 'six-inch';
    final noteForDisplay = _notesController.text.isEmpty
        ? 'No notes added.'
        : _notesController.text;

    // use the local _quantity as source of truth for display and pricing
    final double total = _pricingRepository.totalPrice(
      quantity: _quantity,
      isFootlong: _isFootlong,
    );
    final String totalText = _pricingRepository.formatPrice(total);

    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter', style: heading1)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 12),
            // reactive total display
            Text('Total: $totalText', style: normalText),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(value: _isFootlong, onChanged: _onSandwichTypeChanged),
                const Text('footlong', style: normalText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('untoasted', style: normalText),
                Switch(
                  value: _isToasted,
                  onChanged: (v) => setState(() => _isToasted = v),
                ),
                const Text('toasted', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: _selectedBreadType,
              onSelected: _onBreadTypeSelected,
              dropdownMenuEntries: _buildDropdownEntries(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(children: [Icon(icon), const SizedBox(width: 8), Text(label)]),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): ${'🥪' * quantity}';

    return Column(
      children: [
        Text(displayText, style: normalText),
        const SizedBox(height: 8),
        Text('Note: $orderNote', style: normalText),
      ],
    );
  }
}

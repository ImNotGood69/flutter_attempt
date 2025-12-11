import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _navigateToProfile() async {
    final Map<String, String>? result =
        await Navigator.push<Map<String, String>>(
          context,
          MaterialPageRoute<Map<String, String>>(
            builder: (BuildContext context) => const ProfileScreen(),
          ),
        );

    if (result != null && mounted) {
      _showWelcomeMessage(result);
    }
  }

  void _showWelcomeMessage(Map<String, String> profileData) {
    final String name = profileData['name'] ?? '';
    final String location = profileData['location'] ?? '';
    final String welcomeMessage = 'Welcome, $name! Ordering from $location';

    final SnackBar welcomeSnackBar = SnackBar(
      content: Text(welcomeMessage),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(welcomeSnackBar);
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      final Cart cart = Provider.of<Cart>(context, listen: false);
      cart.add(sandwich, quantity: _quantity);

      final sizeText = _isFootlong ? 'footlong' : 'six-inch';
      final confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmationMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CartScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SettingsScreen(),
      ),
    );
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    final entries = <DropdownMenuEntry<SandwichType>>[];
    for (final type in SandwichType.values) {
      final sandwich = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      );
      entries.add(
        DropdownMenuEntry<SandwichType>(value: type, label: sandwich.name),
      );
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    return BreadType.values
        .map(
          (bread) =>
              DropdownMenuEntry<BreadType>(value: bread, label: bread.name),
        )
        .toList();
  }

  String _getCurrentImagePath() {
    final sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() => _selectedSandwichType = value);
    }
  }

  void _onSizeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  void _increaseQuantity() {
    setState(() => _quantity++);
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) return _decreaseQuantity;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Sandwich Counter'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Image not found', style: normalText),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('six-inch', style: normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  Text('footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: normalText),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToCartView,
                icon: Icons.shopping_cart,
                label: 'View Cart',
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToSettings,
                icon: Icons.settings,
                label: 'Settings',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Text(
                    'Cart: ${cart.countOfItems} items - £${cart.totalPrice().toStringAsFixed(2)}',
                    style: normalText,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// StyledButton now provided by common_widgets.dart

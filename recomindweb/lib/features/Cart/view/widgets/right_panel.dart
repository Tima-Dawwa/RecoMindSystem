import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_page_body.dart';

class Rightpanel extends StatefulWidget {
  const Rightpanel({super.key, required this.cartItems});

  final List<CartItem> cartItems ;

  @override
  State<Rightpanel> createState() => _RightpanelState();
}

class _RightpanelState extends State<Rightpanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Divider(height: 20),
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Text(
                  'Total Items:',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalItems',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  'Total Coast:',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Themes.primary,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: widget.cartItems.isEmpty ? null : _orderNow,
              child: const Text('Order Now'),
            ),
          ),
        ],
      ),
    );
  }

  int get totalItems {
    return widget.cartItems.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void _orderNow() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Order Confirmed'),
            content: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

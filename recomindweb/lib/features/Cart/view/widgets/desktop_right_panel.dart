import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';

class DesktopRightPanel extends StatefulWidget {
  const DesktopRightPanel({super.key, required this.cartItems, required this.totalItems, required this.totalPrice, required this.orderNow});

  final List<CartModel> cartItems;
  final int totalItems;
  final double totalPrice;
  final VoidCallback orderNow;
  @override
  State<DesktopRightPanel> createState() => _DesktopRightPanelState();
}

class _DesktopRightPanelState extends State<DesktopRightPanel> {
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
                    '${widget.totalItems}',
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
                    '\$${widget.totalPrice.toStringAsFixed(2)}',
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
                onPressed: widget.cartItems.isEmpty ? null : widget.orderNow,
                child: const Text('Order Now'),
              ),
            ),
          ],
        ),
      );
  }
}
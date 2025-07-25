import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_item_card.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_page_body.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key, required this.cartItems});

  final List<CartItem> cartItems;

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  Widget build(BuildContext context) {
    int itemOfCart = widget.cartItems.length;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Themes.primary,
                    ),
                  ),
                  Text(
                    '($itemOfCart Items)',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return CartItemCard(
                    name: item.name,
                    imageUrl: item.imageUrl,
                    price: item.price,
                    quantity: item.quantity,
                    onIncrease: () => _increaseQuantity(index),
                    onDecrease: () => _decreaseQuantity(index),
                    onDelete: () => _confirmDeleteItem(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index].quantity > 1) {
        widget.cartItems[index].quantity--;
      }
    });
  }

  void _confirmDeleteItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
            'Are you sure you want to delete this item from the cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.cartItems.removeAt(index);
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}



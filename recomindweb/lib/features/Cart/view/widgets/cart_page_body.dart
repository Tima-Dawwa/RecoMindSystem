import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/features/Cart/view/widgets/left_panel.dart';
import 'package:recomindweb/features/Cart/view/widgets/right_panel.dart';

class CartPageBody extends StatefulWidget {
  const CartPageBody({super.key});

  @override
  State<CartPageBody> createState() => _CartPageBodyState();
}

class _CartPageBodyState extends State<CartPageBody> {
  final List<CartItem> cartItems = [
    CartItem(
      name: 'Product 1',
      imageUrl: 'assets/Images/labels/all1.jpg',
      price: 20.0,
    ),
    CartItem(
      name: 'Product 2',
      imageUrl: 'assets/Images/labels/all1.jpg',
      price: 15.0,
    ),
    CartItem(
      name: 'Product 3',
      imageUrl: 'assets/Images/labels/all1.jpg',
      price: 30.0,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftPanel(cartItems: cartItems),
          Rightpanel(cartItems: cartItems),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}

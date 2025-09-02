import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_item_card.dart';
import 'package:recomindweb/features/Cart/view/widgets/hybrid_products.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key, required this.cartItems, required this.hybridProduct});

  final List<CartModel> cartItems;
  final List<AllProductsModel> hybridProduct;

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
            if (widget.cartItems.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: Text(
                    "Not Items",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return CartItemCard(
                      index: index,
                      name: item.name,
                      imageUrl: item.image,
                      price: item.price,
                      quantity: item.quantity,
                      color: item.color,
                      department: item.department,
                      onIncrease: () => _increaseQuantity(index),
                      onDecrease: () => _decreaseQuantity(index),
                      onDelete: () => _confirmDeleteItem(item.id),
                    );
                  },
                ),
              ),
           HybridProducts(products: widget.hybridProduct)
          ],
        ),
      ),
    );
  }

  void _increaseQuantity(int index) {
    BlocProvider.of<CartCubit>(context).increaseQuantity(index);
  }

  void _decreaseQuantity(int index) {
    BlocProvider.of<CartCubit>(context).decreaseQuantity(index);
  }

  void _confirmDeleteItem(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<CartCubit, CartStates>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Delete Item'),
              content:
                  state is RemoveFromCartLoadingState
                      ? SizedBox(
                        height: 80,
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : const Text(
                        'Are you sure you want to delete this item from the cart?',
                      ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<CartCubit>(
                      context,
                    ).removeFromCart(id, context);
                  },
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

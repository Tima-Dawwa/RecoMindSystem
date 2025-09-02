import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
import 'package:recomindweb/features/Cart/view/widgets/desktop_right_panel.dart';
import 'package:recomindweb/features/Cart/view/widgets/mobile_right_panel.dart';

class Rightpanel extends StatefulWidget {
  const Rightpanel({super.key, required this.cartItems, required this.desktop});

  final List<CartModel> cartItems;
  final bool desktop;

  @override
  State<Rightpanel> createState() => _RightpanelState();
}

class _RightpanelState extends State<Rightpanel> {
  @override
  Widget build(BuildContext context) {
    if (widget.desktop) {
      return DesktopRightPanel(
        cartItems: widget.cartItems,
        totalItems: totalItems,
        totalPrice: totalPrice,
        orderNow: _orderNow,
      );
    } else {
      return MobileRightPanel(
        cartItems: widget.cartItems,
        totalItems: totalItems,
        totalPrice: totalPrice,
        orderNow: _orderNow,
      );
    }
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
    BlocProvider.of<CartCubit>(context).makeOrder();
    // showDialog(
    //   context: context,
    //   builder:
    //       (_) => AlertDialog(
    //         title: const Text('Order Confirmed'),
    //         content: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: const Text('OK'),
    //           ),
    //         ],
    //       ),
    // );
  }
}

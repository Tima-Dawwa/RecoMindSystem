import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view/widgets/left_panel.dart';
import 'package:recomindweb/features/Cart/view/widgets/right_panel.dart';

class CartPageBody extends StatefulWidget {
  const CartPageBody({
    super.key,
    required this.cartItems,
    required this.desktop,
  });
  final List<CartModel> cartItems;
  final bool desktop;

  @override
  State<CartPageBody> createState() => _CartPageBodyState();
}

class _CartPageBodyState extends State<CartPageBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.desktop) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeftPanel(cartItems: widget.cartItems),
            Rightpanel(cartItems: widget.cartItems , desktop: true,),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            LeftPanel(cartItems: widget.cartItems),
            Rightpanel(cartItems: widget.cartItems , desktop: false,),
          ],
        ),
      );
    }
  }
}

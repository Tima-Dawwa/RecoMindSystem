import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_page_body.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return Center(child: CustomLoading());
          } else if (state is CartSuccessState) {
            List<CartModel> cartItems =
                BlocProvider.of<CartCubit>(context).cartItems;
            return
            ResponsiveLayout(
              mobileBody: CartPageBody(cartItems: cartItems , desktop: false,),
              desktopBody: CartPageBody(cartItems: cartItems , desktop: true,),
            );
          } else {
            return Text("Failure");
          }
        },
      ),
    );
  }

  Future<void> getCart() async {
    await BlocProvider.of<CartCubit>(context).getCart();
  }
}

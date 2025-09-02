import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/Widgets/paypal_widget.dart';
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
      body: BlocConsumer<CartCubit, CartStates>(
        listener: (context, state) {
          if (state is RemoveFromCartSuccessState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RemoveFromCartFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.errMessage)));
          } else if (state is MakeOrderFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.errMessage)));
          }
        },
        builder: (context, state) {
          if (state is CartLoadingState || state is MakeOrderLoadingState) {
            return Center(child: CustomLoading());
          } else if (state is CartSuccessState ||
              state is RemoveFromCartSuccessState ||
              state is RemoveFromCartLoadingState) {
            List<CartModel> cartItems =
                BlocProvider.of<CartCubit>(context).cartItems;
            return ResponsiveLayout(
              mobileBody: CartPageBody(cartItems: cartItems, desktop: false),
              desktopBody: CartPageBody(cartItems: cartItems, desktop: true),
            );
          } else if (state is MakeOrderSuccessState) {
            print(state);
            Get.to(
              () => PayPal(
                url: "",
                onSuccess: () {
                  Get.off(() => CartPage());
                },
              ),
            );
             List<CartModel> cartItems =
                BlocProvider.of<CartCubit>(context).cartItems;
            return ResponsiveLayout(
              mobileBody: CartPageBody(cartItems: cartItems, desktop: false),
              desktopBody: CartPageBody(cartItems: cartItems, desktop: true),
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

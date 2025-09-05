import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class HybridImage extends StatefulWidget {
  final AllProductsModel product;
  final int? index;

  const HybridImage({
    super.key,
    required this.product,
    this.index,
 
  });

  @override
  State<HybridImage> createState() => _HybridState();
}

class _HybridState extends State<HybridImage> {

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            Image.network(
              '${getIt.get<Api>().baseUrl}${product.urlImage}',
              headers: {"ngrok-skip-browser-warning": "true"},
              fit: BoxFit.fill,
              width: double.infinity,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () async {
                  print("s111111111");
                  print(widget.product.isFav);
                  if (widget.product.isFav) {
                    await BlocProvider.of<CartCubit>(
                      context,
                    ).deleteFavorite(
                      productId: widget.product.id,
                      index: widget.index!,
                    );
                    print('no');
                  } else {
                    print('yes');
                    await BlocProvider.of<CartCubit>(
                      context,
                    ).addToFavorites(
                      productId: widget.product.id,
                      index: widget.index!,
                    );
                    print("2yes");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: BlocBuilder<CartCubit, CartStates>(
                    builder: (context, state) {
                      return Icon(
                        product.isFav ? Icons.favorite : Icons.favorite_border,
                        color:
                            product.isFav
                                ? Themes.secondary
                                : Themes.text.withAlpha(150),
                        size: 20,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

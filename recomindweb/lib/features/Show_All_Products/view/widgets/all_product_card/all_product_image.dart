import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class AllProductImage extends StatefulWidget {
  final AllProductsModel product;
  final int? index;

  const AllProductImage({
    super.key,
    required this.product,
    this.index,
  });

  @override
  State<AllProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<AllProductImage> {
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
                onTap: () {
                  
                  if (widget.product.isFav) {
                    BlocProvider.of<CartCubit>(context).deleteFavorite(
                      productId: product.id,
                      index: widget.index!,
                    );
                  } else {
                    BlocProvider.of<CartCubit>(context).addToFavorites(
                      productId: product.id,
                      index: widget.index!,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    product.isFav ? Icons.favorite : Icons.favorite_border,
                    color:
                        product.isFav
                            ? Themes.secondary
                            : Themes.text.withAlpha(150),
                    size: 20,
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

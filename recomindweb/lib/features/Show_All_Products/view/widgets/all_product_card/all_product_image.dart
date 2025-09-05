import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';

class AllProductImage extends StatefulWidget {
  final AllProductsModel product;
  final int? index;
  final VoidCallback addFav;
  final VoidCallback delFav;

  const AllProductImage({
    super.key,
    required this.product,
    this.index,
    required this.addFav,
    required this.delFav,
  });

  @override
  State<AllProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<AllProductImage> {
  // late bool isFav;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   isFav = widget.product.isFav;
  // }

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
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<AllProductsCubit, AllProductsState>(
                  builder: (context, state) {
                    if (product.isNew & product.isTrend) {
                      return Text(" New and Trend ");
                    } else if (product.isNew) {
                      return Text(" New ");
                    } else {
                      return Text('Trend ');
                    }
                  },
                ),
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
                    await BlocProvider.of<AllProductsCubit>(
                      context,
                    ).deleteFavorite(
                      productId: widget.product.id,
                      index: widget.index!,
                    );
                    print('no');
                  } else {
                    print('yes');
                    await BlocProvider.of<AllProductsCubit>(
                      context,
                    ).addToFavorites(
                      productId: widget.product.id,
                      index: widget.index!,
                    );
                    print("2yes");
                  }
                  // if (widget.product.isFav) {
                  //   print("zzzzz ${widget.product.isFav}");
                  //   await BlocProvider.of<AllProductsCubit>(
                  //     context,
                  //   ).deleteFavorite(
                  //     productId: widget.product.id,
                  //     index: widget.index!,
                  //   );
                  // } else {
                  //   await BlocProvider.of<AllProductsCubit>(
                  //     context,
                  //   ).addToFavorites(
                  //     productId: widget.product.id,
                  //     index: widget.index!,
                  //   );
                  // }
                  // setState(() {
                  //   // isFav = !isFav;
                  // });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: BlocBuilder<AllProductsCubit, AllProductsState>(
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

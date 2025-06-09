import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';

class ProductImageSectionMobile extends StatefulWidget {
  final String selectedImage;
  final Function(String) onThumbnailClick;
  final List<String> imageList;
  final Product product;

  const ProductImageSectionMobile({
    super.key,
    required this.selectedImage,
    required this.onThumbnailClick,
    required this.imageList,
    required this.product,
  });

  @override
  State<ProductImageSectionMobile> createState() =>
      _ProductImageSectionMobileState();
}

class _ProductImageSectionMobileState extends State<ProductImageSectionMobile> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final productDetailsCubit = context.read<ProductDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.selectedImage,
                      headers: {"ngrok-skip-browser-warning": "true"},
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.product.isfavorite) {
                          productDetailsCubit.deleteFavorite(widget.product.id,
                            widget.product.id,
                          );
                        } else {
                          productDetailsCubit.addToFavorites(widget.product.id,
                            widget.product.id,
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Themes.bg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Themes.text.withAlpha(150),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.product.isfavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            isFavorite
                                ? Themes.secondary
                                : Themes.text.withAlpha(150),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (widget.imageList.length > 1)
            SizedBox(
              height: 100,
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: widget.imageList.length,
                  itemBuilder: (context, index) {
                    final image = widget.imageList[index];
                    final isSelected = image == widget.selectedImage;

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => widget.onThumbnailClick(image),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Themes.primary
                                      : Colors.transparent,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Themes.text.withAlpha(40),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                                headers: {"ngrok-skip-browser-warning": "true"},
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

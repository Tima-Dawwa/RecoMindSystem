import 'package:flutter/material.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_image.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_price.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_rating.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_tags_row.dart';

class AllProductCard extends StatelessWidget {
  final AllProductsModel product;
  final VoidCallback onTap;

  const AllProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AllProductImage(product: product),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AllProductTagsRow(product: product),
                  const SizedBox(height: 6),
                  AllProductRating(rating: product.rating),
                  const SizedBox(height: 6),
                  AllProductPrice(
                    price: product.price,
                    discPrice: product.discountedPrice,
                    isDisc: product.isDiscounted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

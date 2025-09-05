import 'package:flutter/material.dart';
import 'package:recomindweb/features/Cart/view/widgets/hybrid_card/hybrid_image.dart';
import 'package:recomindweb/features/Cart/view/widgets/hybrid_card/hybrid_price.dart';
import 'package:recomindweb/features/Cart/view/widgets/hybrid_card/hybrid_rating.dart';
import 'package:recomindweb/features/Cart/view/widgets/hybrid_card/hybrid_row.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class HybridCard extends StatefulWidget {
  final AllProductsModel product;
  final VoidCallback onTap;
  final int? index;


  const HybridCard({
    super.key,
    required this.product,
    required this.onTap,
    this.index,

  });

  @override
  State<HybridCard> createState() => _HybridCardState();
}

class _HybridCardState extends State<HybridCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
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
            HybridImage(
              product: widget.product,
              index: widget.index,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  HybridTagsRow(product: widget.product),
                  const SizedBox(height: 6),
                  HybridRating(rating: widget.product.rating),
                  const SizedBox(height: 6),
                  HybridPrice(
                    price: widget.product.price,
                    discPrice: widget.product.discountedPrice,
                    isDisc: widget.product.isDiscounted,
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

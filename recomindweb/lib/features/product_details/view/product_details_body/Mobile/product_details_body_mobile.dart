import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_response.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_header_mobile.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_image_selction_mobile.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/recommendation_product.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_review_selection.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/customers_review.dart';

class ProductDetailsMobileLayout extends StatelessWidget {
  final ValueChanged<String> onImageChange;
  final ProductResponse product;
  const ProductDetailsMobileLayout({
    super.key,

    required this.onImageChange,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageSectionMobile(
          selectedImage:
              'https://5768-109-236-81-168.ngrok-free.app${product.data.images[0]}',
          imageList: product.data.images,
          onThumbnailClick: onImageChange,
          product: product.data,
        ),
        ProductHeaderMobile(product: product.data),
        Divider(thickness: 1, color: Themes.text.withAlpha(20)),
        AddReviewSection(product: product.data),
        Divider(thickness: 1, color: Themes.text.withAlpha(20)),
        CustomerReviews(product: product.data),
        Divider(thickness: 1, color: Themes.text.withAlpha(20)),
        RecommendationProductMobile(products: product.recommendations),
      ],
    );
  }
}

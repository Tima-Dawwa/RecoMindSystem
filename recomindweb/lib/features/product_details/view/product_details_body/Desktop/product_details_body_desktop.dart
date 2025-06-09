import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/models/product_response.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/recommendation_product_desktop.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_review_selection.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/customers_review.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_header.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_image_section.dart';

class ProductDetailsDesktopLayout extends StatelessWidget {

  final ValueChanged<String> onImageChange;
  final ProductResponse productData;
  const ProductDetailsDesktopLayout({
    super.key,

    required this.onImageChange,
    required this.productData,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(
              selectedImage: 'https://c4dd-190-2-147-86.ngrok-free.app${productData.data.images[0]}',
              imageList: productData.data.images,
              onThumbnailClick: onImageChange,
              product: productData.data,
            ),
            const SizedBox(width: 8),
            Expanded(child: ProductHeader(product: productData.data,)),
          ],
        ),
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        const AddReviewSection(),
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        CustomerReviews(product: productData.data,),
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        RecommendationProductDesktop(
          products: productData.recommendations,
        
         
        ),
      ],
    );
  }
}

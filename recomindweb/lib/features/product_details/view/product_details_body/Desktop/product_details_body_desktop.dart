import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_review_selection.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/customers_review.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_header.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_image_section.dart';

class ProductDetailsDesktopLayout extends StatelessWidget {
  final String selectedImage;
  final List<String> images;
  final ValueChanged<String> onImageChange;

  const ProductDetailsDesktopLayout({
    super.key,
    required this.selectedImage,
    required this.images,
    required this.onImageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(
              selectedImage: selectedImage,
              imageList: images,
              onThumbnailClick: onImageChange,
            ),
            const SizedBox(width: 8),
            Expanded(child: ProductHeader()),
          ],
        ),
        Divider(thickness: 1, color: Colors.grey[300]),
        const AddReviewSection(),
        Divider(thickness: 1, color: Colors.grey[300]),
        CustomerReviews(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_header_mobile.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_image_selction_mobile.dart';

class ProductDetailsMobileLayout extends StatelessWidget {
  final String selectedImage;
  final List<String> images;
  final ValueChanged<String> onImageChange;

  const ProductDetailsMobileLayout({
    super.key,
    required this.selectedImage,
    required this.images,
    required this.onImageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageSectionMobile(
          selectedImage: selectedImage,
          imageList: images,
          onThumbnailClick: onImageChange,
        ),
        // Uncomment other sections as needed
        ProductHeaderMobile(),
        // Divider(thickness: 1, color: Colors.grey[300]),
        // const AddReviewSection(),
        // Divider(thickness: 1, color: Colors.grey[300]),
        // CustomerReviews(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/recommendation_product_desktop.dart';
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
    final List<Product> products = [
      Product(
        name: "Product A",
        imageUrl: "assets/Images/main_side.png",
        price: 29.99,
        discountPercent: 25,
        isFavorite: false,
        gender: "Female",
        category: "Ladieswear",
        isTrending: true,
        rating: 4.5,
        tagType: "Trend",
      ),
      Product(
        name: "Product B",
        imageUrl: "assets/Images/main_side.png",
        price: 49.99,
        discountPercent: 10,
        isFavorite: true,
        gender: "Male",
        category: "Menswear",
        isTrending: false,
        rating: 3.8,
        tagType: "New",
      ),
      Product(
        name: "Product C",
        imageUrl: "assets/Images/main_side.png",
        price: 19.99,
        discountPercent: null,
        isFavorite: false,
        gender: "Unisex",
        category: "Accessories",
        isTrending: false,
        rating: 4.0,
        tagType: "Trend",
      ),
    ];
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
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        const AddReviewSection(),
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        CustomerReviews(),
        Divider(thickness: 1, color: Themes.text.withAlpha(30)),
        RecommendationProductDesktop(
          products: products,
          onCardTap: (product) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tapped on ${product.name}")),
            );
          },
        ),
      ],
    );
  }
}

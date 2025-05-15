import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/app_scafold.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_review_selection.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/customers_review.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_header_section.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_image_section.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String _selectedImage;
  final List<String> _images = [
    'assets/main_side.png',
    'assets/front_side.png',
    'assets/back_side.png',
  ];

  @override
  void initState() {
    super.initState();
    _selectedImage = _images[0];
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProductImageSection(
                selectedImage: _selectedImage,
                imageList: _images,
                onThumbnailClick: (String newImage) {
                  setState(() {
                    _selectedImage = newImage;
                  });
                },
              ),
              const SizedBox(width: 16),
              Expanded(child: ProductHeader()),
            ],
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          const AddReviewSection(),
          Divider(thickness: 1, color: Colors.grey[300]),
          CustomerReviews()
        ]),
      ),
    );
  }
}

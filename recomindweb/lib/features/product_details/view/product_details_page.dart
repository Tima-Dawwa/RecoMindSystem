import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/color_selctor.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/customers_review.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_header_section.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_image_section.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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

            CustomerReviews()
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/core/widgets/app_scafold.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_details_body_desktop.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_details_body_mobile.dart';

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
    return ResponsiveLayout(
      mobileBody: AppScaffold(
        child: ProductDetailsMobileLayout(
          selectedImage: _selectedImage,
          images: _images,
          onImageChange: (img) => setState(() => _selectedImage = img),
        ),
      ),
      desktopBody: AppScaffold(
        child: ProductDetailsDesktopLayout(
          selectedImage: _selectedImage,
          images: _images,
          onImageChange: (img) => setState(() => _selectedImage = img),
        ),
      ),
    );
  }
}

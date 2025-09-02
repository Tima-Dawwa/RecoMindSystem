import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/core/widgets/app_scafold.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_state.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/product_details_body_desktop.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Mobile/product_details_body_mobile.dart';

class ProductDetailsPage extends StatefulWidget {
  final String? productId;

  const ProductDetailsPage({super.key, this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String _selectedImage;

  @override
  void initState() {
    super.initState();

    final productDetailsCubit = context.read<ProductDetailsCubit>();
    productDetailsCubit.fetchProduct(productId: widget.productId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is LoadingProductDetails) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SuccessProductDetails) {
          return ResponsiveLayout(
            mobileBody: AppScaffold(
              child: ProductDetailsMobileLayout(
                onImageChange: (img) => setState(() => _selectedImage = img),
                product: state.product,
              ),
            ),
            desktopBody: AppScaffold(
              child: ProductDetailsDesktopLayout(
                onImageChange: (img) => setState(() => _selectedImage = img),
                productData: state.product,
              ),
            ),
          );
        } else if (state is FailureProductDetails) {
          return Center(child: Text('Error: ${state.failure.errMessage}'));
        } else {
          return Container();
        }
      },
    );
  }
}

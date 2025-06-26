import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatefulWidget {
  final List<AllProductModel> products;
  final Set<String> selectedProducts;
  final Function(String) onProductTap;
  final Function(String) onProductDoubleTap;
  final VoidCallback? onLoadMore;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.onProductTap,
    required this.onProductDoubleTap,
    this.onLoadMore,
  });

  @override
  State<ProductsGridView> createState() => _ProductsGridViewCubitState();
}

class _ProductsGridViewCubitState extends State<ProductsGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth < 700) {
          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            itemCount: widget.products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return ProductCard(
                product: product,
                isSelected: widget.selectedProducts.contains(product.id),
                onTap: () => widget.onProductTap(product.id),
                onDoubleTap: () => widget.onProductDoubleTap(product.id),
                isCompactView: true,
              );
            },
          );
        } else {
          int crossAxisCount;
          double childAspectRatio;
          double crossAxisSpacing = 16;
          double mainAxisSpacing = 16;

          if (screenWidth >= 1600) {
            crossAxisCount = 5;
            childAspectRatio = 0.95;
          } else if (screenWidth >= 1300) {
            crossAxisCount = 4;
            childAspectRatio = 0.95;
          } else if (screenWidth >= 1000) {
            crossAxisCount = 3;
            childAspectRatio = 0.95;
          } else {
            crossAxisCount = 2;
            childAspectRatio = 0.85;
            crossAxisSpacing = 12;
            mainAxisSpacing = 12;
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              
              return ProductCard(
                product: product,
                isSelected: widget.selectedProducts.contains(product.id),
                onTap: () => widget.onProductTap(product.id),
                onDoubleTap: () => widget.onProductDoubleTap(product.id),
                isCompactView: false,
              );
            },
          );
        }
      },
    );
  }
}

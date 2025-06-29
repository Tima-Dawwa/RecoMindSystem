import 'dart:io';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/dashboard_card.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/product_form.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/rating_card.dart';
import 'package:flutter/foundation.dart';
import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/status_card.dart';
import 'package:flutter/material.dart';


class ProductDetailsView extends StatelessWidget {
  final ProductModel product;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final TextEditingController quantityController;
  final TextEditingController colorController;

  final String? selectedType;
  final String? selectedDepartment;
  final String? selectedGender;
  final String? selectedAppearance;

  final List<String> types;
  final List<String> departments;
  final List<String> genders;
  final List<String> appearances;

  final List<String> imagesToKeep;
  final List<String> originalImages;
  final List<String> newImages;
  final List<Uint8List> newImageBytes;

  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onAppearanceChanged;
  final VoidCallback onPickMultipleImages;
  final Function(int) onRemoveExistingImage;
  final Function(int) onRemoveNewImage;
  final Function(String) onRestoreImage;
  final VoidCallback onRestoreAllImages;

  const ProductDetailsView({
    super.key,
    required this.product,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.discountPriceController,
    required this.quantityController,
    required this.colorController,
    required this.selectedType,
    required this.selectedDepartment,
    required this.selectedGender,
    required this.selectedAppearance,
    required this.types,
    required this.departments,
    required this.genders,
    required this.appearances,
    required this.imagesToKeep,
    required this.originalImages,
    required this.newImages,
    required this.newImageBytes,
    required this.onTypeChanged,
    required this.onDepartmentChanged,
    required this.onGenderChanged,
    required this.onAppearanceChanged,
    required this.onPickMultipleImages,
    required this.onRemoveExistingImage,
    required this.onRemoveNewImage,
    required this.onRestoreImage,
    required this.onRestoreAllImages,
  });

  Widget _buildStatsRow(ProductModel product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Total Favorites',
                      value: (product.numFavorites).toString(),
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Total Sales',
                      value: (product.numSales).toString(),
                      icon: Icons.shopping_cart,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Page Views',
                      value: (product.numViews).toString(),
                      icon: Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RatingCard(
                      averageRating: product.ratings.averageRating,
                      reviewCount: product.ratings.count,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Total Favorites',
                  value: (product.numFavorites).toString(),
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Total Sales',
                  value: (product.numSales).toString(),
                  icon: Icons.shopping_cart,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Page Views',
                  value: (product.numViews).toString(),
                  icon: Icons.visibility,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: RatingCard(
                  averageRating: product.ratings.averageRating,
                  reviewCount: product.ratings.count,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildProductImagesCard() {
    return DashboardCard(
      title: 'Product Images',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Images Section
          if (imagesToKeep.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Images (${imagesToKeep.length} of ${originalImages.length} kept):',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (imagesToKeep.length < originalImages.length)
                  TextButton.icon(
                    onPressed: onRestoreAllImages,
                    icon: const Icon(Icons.restore, size: 16),
                    label: const Text('Restore All'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue[600],
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageGrid(
              imagesToKeep,
              onRemoveExistingImage,
              isNetworkImage: true,
            ),
          ],

          if (imagesToKeep.length < originalImages.length) ...[
            const SizedBox(height: 20),
            _buildRemovedImagesSection(),
          ],

          if (newImages.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Images (${newImages.length}):',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                  
                    onRemoveNewImage(
                      -1,
                    );
                  },
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageGrid(newImages, onRemoveNewImage, isNetworkImage: false),
          ],

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: onPickMultipleImages,
              icon: const Icon(Icons.add_photo_alternate, size: 20),
              label: const Text('Add New Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          if (imagesToKeep.isEmpty && newImages.isEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No Images Selected',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Product will have no images. Add new images or restore some original images.',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageGrid(
    List<String> images,
    Function(int) onRemove, {
    required bool isNetworkImage,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(images[index], index, isNetworkImage),
              ),
            ),
            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
            // New image indicator
            if (!isNetworkImage)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImageWidget(String imagePath, int index, bool isNetworkImage) {
    if (isNetworkImage) {
      return Image.network(
        "$ngrok$imagePath",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        headers: const {"ngrok-skip-browser-warning": "true"},
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, color: Colors.grey[600], size: 32),
          );
        },
      );
    } else {
      if (kIsWeb) {
        if (index < newImageBytes.length) {
          return Image.memory(
            newImageBytes[index],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[600],
                  size: 32,
                ),
              );
            },
          );
        } else {
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, color: Colors.grey[600], size: 32),
          );
        }
      } else {
        return Image.file(
          File(imagePath),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.broken_image,
                color: Colors.grey[600],
                size: 32,
              ),
            );
          },
        );
      }
    }
  }

  Widget _buildRemovedImagesSection() {
    List<String> removedImages =
        originalImages.where((image) => !imagesToKeep.contains(image)).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Removed Images (${removedImages.length}):',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: onRestoreAllImages,
                icon: const Icon(Icons.restore, size: 16),
                label: const Text('Restore All'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red[600],
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                removedImages.map((imageUrl) {
                  return GestureDetector(
                    onTap: () => onRestoreImage(imageUrl),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              "$ngrok$imageUrl",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.red.withOpacity(0.7),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.restore,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        Widget productInfoCard = DashboardCard(
          title: 'Product Information',
          child: ProductForm(
            nameController: nameController,
            descriptionController: descriptionController,
            priceController: priceController,
            discountPriceController: discountPriceController,
            colorController: colorController,
            quantityController: quantityController,
            selectedCategory: selectedType ?? types.first,
            selectedDepartment: selectedDepartment ?? departments.first,
            selectedGender: selectedGender ?? genders.first,
            selectedAppearance: selectedAppearance ?? appearances.first,
            categories: types,
            departments: departments,
            genders: genders,
            appearances: appearances,
            onCategoryChanged: onTypeChanged,
            onDepartmentChanged: onDepartmentChanged,
            onGenderChanged: onGenderChanged,
            onAppearanceChanged: onAppearanceChanged,
            isMobile: isMobile,
          ),
        );

        Widget productImagesCard = _buildProductImagesCard();

        if (isMobile) {
          return Column(
            children: [
              productInfoCard,
              const SizedBox(height: 24),
              productImagesCard,
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: productInfoCard),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: productImagesCard),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatsRow(product),
          const SizedBox(height: 20),
          _buildMainContent(),
        ],
      ),
    );
  }
}

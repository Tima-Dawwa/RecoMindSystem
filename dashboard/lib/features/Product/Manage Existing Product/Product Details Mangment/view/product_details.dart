import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_mangment_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_managment_states.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'widgets/rating_card.dart';
import 'widgets/product_form.dart';
import 'widgets/dashboard_card.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _colorController;

  String? _selectedType;
  String? _selectedDepartment;
  String? _selectedGender;
  String? _selectedAppearance;
  List<String> _originalImages = [];
  List<String> _imagesToKeep = [];
  List<String> _newImages = [];
  List<Uint8List> _newImageBytes = [];
  bool _isDataPopulated = false;

  final String _baseUrl = 'https://54d9-143-244-44-175.ngrok-free.app';

  List<String> get _types => departments.isNotEmpty ? departments : ['Default'];
  List<String> get _departments =>
      categories.isNotEmpty ? categories : ['Default'];
  List<String> get _genders => genders.isNotEmpty ? genders : ['Default'];
  List<String> get _appearances =>
      appearances.isNotEmpty ? appearances : ['Default'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    context.read<ManageProductCubit>().getProduct(id: widget.productId);
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _discountPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _colorController = TextEditingController();
  }

  void _populateFields(ProductModel product) {
    if (_isDataPopulated) return;

    _nameController.text = product.name;
    _descriptionController.text = product.details;
    _priceController.text = product.price.toString();
    _discountPriceController.text = product.discountedPrice.toString();
    _quantityController.text = product.quantity.toString();
    _colorController.text = product.color;

    _selectedAppearance =
        _appearances.contains(product.graphic)
            ? product.graphic
            : _appearances.first;

    _selectedType = _types.contains(product.type) ? product.type : _types.first;

    _selectedDepartment =
        _departments.contains(product.department)
            ? product.department
            : _departments.first;

    _selectedGender =
        _genders.contains(product.gender) ? product.gender : _genders.first;

    _originalImages = product.images;
    _imagesToKeep = product.images;
    _newImages.clear();
    _newImageBytes.clear();

    _isDataPopulated = true;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _quantityController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickMultipleImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          for (var file in result.files) {
            if (kIsWeb) {
              if (file.bytes != null) {
                _newImageBytes.add(file.bytes!);
                _newImages.add(file.name);
              }
            } else {
              if (file.path != null) {
                _newImages.add(file.path!);
              }
            }
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e');
    }
  }

  void _removeExistingImage(int index) {
    if (index >= 0 && index < _imagesToKeep.length) {
      setState(() {
        _imagesToKeep.removeAt(index);
      });
    }
  }

  void _removeNewImage(int index) {
    if (index >= 0 && index < _newImages.length) {
      setState(() {
        _newImages.removeAt(index);
        if (kIsWeb && index < _newImageBytes.length) {
          _newImageBytes.removeAt(index);
        }
      });
    }
  }

  void _restoreImage(String imageUrl) {
    if (_originalImages.contains(imageUrl) &&
        !_imagesToKeep.contains(imageUrl)) {
      setState(() {
        _imagesToKeep.add(imageUrl);
      });
    }
  }

  void _restoreAllImages() {
    setState(() {
      _imagesToKeep = List.from(_originalImages);
    });
  }

  List<String> _getImagesToKeepForBackend() {
    return _imagesToKeep;
  }

  void _saveProduct() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a product name');
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      _showSnackBar('Please enter a product price');
      return;
    }
    if (_selectedType == null ||
        _selectedDepartment == null ||
        _selectedGender == null ||
        _selectedAppearance == null) {
      _showSnackBar('Please select all required fields');
      return;
    }

    double? price = double.tryParse(_priceController.text.trim());
    double? discountPrice = double.tryParse(
      _discountPriceController.text.trim(),
    );
    int? quantity =
        _quantityController.text.trim().isNotEmpty
            ? int.tryParse(_quantityController.text.trim())
            : 0;

    if (price == null || price <= 0) {
      _showSnackBar('Please enter a valid price');
      return;
    }
    if (quantity == null || quantity < 0) {
      _showSnackBar('Please enter a valid quantity');
      return;
    }
    if (discountPrice != null && discountPrice >= price) {
      _showSnackBar('Discount price must be less than regular price');
      return;
    }

    List<String> imagesToKeepForBackend = _getImagesToKeepForBackend();

    context.read<ManageProductCubit>().updateProduct(
      id: widget.productId,
      name: _nameController.text.trim(),
      details: _descriptionController.text.trim(),
      type: _selectedType!,
      department: _selectedDepartment!,
      color: _colorController.text.trim(),
      gender: _selectedGender!,
      price: price,
      discountPrice: discountPrice,
      quantity: quantity,
      appearance: _selectedAppearance!,
      imagesToKeep: imagesToKeepForBackend,
      newImages: _newImages,
      newImageBytes: kIsWeb ? _newImageBytes : null,
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
  }

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

  Widget _buildProductImagesCard(ProductModel product) {
    return DashboardCard(
      title: 'Product Images',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Images Section
          if (_imagesToKeep.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Images (${_imagesToKeep.length} of ${_originalImages.length} kept):',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (_imagesToKeep.length < _originalImages.length)
                  TextButton.icon(
                    onPressed: _restoreAllImages,
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
              _imagesToKeep,
              _removeExistingImage,
              isNetworkImage: true,
            ),
          ],

          // Removed Images Section
          if (_imagesToKeep.length < _originalImages.length) ...[
            const SizedBox(height: 20),
            _buildRemovedImagesSection(),
          ],

          // New Images Section
          if (_newImages.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Images (${_newImages.length}):',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _newImages.clear();
                      _newImageBytes.clear();
                    });
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
            _buildImageGrid(_newImages, _removeNewImage, isNetworkImage: false),
          ],

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _pickMultipleImages,
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

          if (_imagesToKeep.isEmpty && _newImages.isEmpty) ...[
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
        "$_baseUrl$imagePath",
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
      if (kIsWeb) {
        if (index < _newImageBytes.length) {
          return Image.memory(
            _newImageBytes[index],
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
            child: Icon(
              Icons.broken_image,
              color: Colors.grey[600],
              size: 32,
            ),
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
        _originalImages
            .where((image) => !_imagesToKeep.contains(image))
            .toList();

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
                onPressed: _restoreAllImages,
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
                    onTap: () => _restoreImage(imageUrl),
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
                              "$_baseUrl$imageUrl",
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

  Widget _buildMainContent(ProductModel product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        Widget productInfoCard = DashboardCard(
          title: 'Product Information',
          child: ProductForm(
            nameController: _nameController,
            descriptionController: _descriptionController,
            priceController: _priceController,
            discountPriceController: _discountPriceController,
            colorController: _colorController,
            quantityController: _quantityController,
            selectedCategory: _selectedType ?? _types.first,
            selectedDepartment: _selectedDepartment ?? _departments.first,
            selectedGender: _selectedGender ?? _genders.first,
            selectedAppearance: _selectedAppearance ?? _appearances.first,
            categories: _types,
            departments: _departments,
            genders: _genders,
            appearances: _appearances,
            onCategoryChanged: (value) {
              setState(() {
                _selectedType = value;
              });
            },
            onDepartmentChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            onGenderChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            onAppearanceChanged: (value) {
              setState(() {
                _selectedAppearance = value;
              });
            },
            isMobile: isMobile,
          ),
        );

        Widget productImagesCard = _buildProductImagesCard(product);

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Product Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
        actions: [
          BlocBuilder<ManageProductCubit, ManageProductStates>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed:
                      state is LoadingManageProduct ? null : _saveProduct,
                  icon:
                      state is LoadingManageProduct
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.save, size: 18),
                  label: Text(
                    state is LoadingManageProduct
                        ? 'Saving...'
                        : 'Save Changes',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ManageProductCubit, ManageProductStates>(
        listener: (context, state) {
          if (state is SuccessManageProduct) {
            _showSnackBar('Product updated successfully!');
            _isDataPopulated = false;
            final cubit = context.read<ManageProductCubit>();
            if (cubit.hasProduct) {
              _populateFields(cubit.product!);
            }
          } else if (state is FailureManageProduct) {
            _showSnackBar('Error: ${state.failure.errMessage}');
          }
        },
        builder: (context, state) {
          if (state is LoadingManageProduct &&
              !context.read<ManageProductCubit>().hasProduct) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading product details...'),
                ],
              ),
            );
          }

          if (state is FailureManageProduct &&
              !context.read<ManageProductCubit>().hasProduct) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.failure.errMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ManageProductCubit>().getProduct(
                        id: widget.productId,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final cubit = context.read<ManageProductCubit>();
          if (!cubit.hasProduct) {
            return const Center(child: Text('No product data available'));
          }

          final product = cubit.product!;
          if (!_isDataPopulated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFields(product);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildStatsRow(product),
                const SizedBox(height: 20),
                _buildMainContent(product),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/widgets/image_section.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'widgets/rating_card.dart';
import 'widgets/product_form.dart';
import 'widgets/dashboard_card.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _colorController;

  late String _selectedCategory;
  late String _selectedDepartment;
  late String _selectedGender;
  late List<String> _imageUrls;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Accessories',
  ];

  final List<String> _departments = [
    'Men\'s ',
    'Women\'s',
    'Kids ',
    'Home ',
    'Electronics ',
    'Accessories ',
  ];

  final List<String> _genders = ['Male', 'Female', 'Unisex'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeDropdownValues();
    _imageUrls = List.from(widget.product.imageUrls);
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _discountPriceController = TextEditingController(
      text: widget.product.discountPrice?.toString() ?? '',
    );
    _colorController = TextEditingController(text: widget.product.color);
  }

  void _initializeDropdownValues() {
    _selectedCategory =
        _categories.contains(widget.product.category)
            ? widget.product.category
            : _categories.first;
    _selectedDepartment = _mapDepartmentValue(widget.product.department);
    _selectedGender =
        _genders.contains(widget.product.gender)
            ? widget.product.gender
            : _genders.first;
  }

  String _mapDepartmentValue(String oldDepartment) {
    final departmentLower = oldDepartment.toLowerCase().trim();
    switch (departmentLower) {
      case 'men':
        return 'Men\'s ';
      case 'women':
        return 'Women\'s';
      case 'kids':
      case 'children':
        return 'Kids ';
      case 'home':
        return 'Home ';
      case 'electronics':
        return 'Electronics ';
      case 'accessory':
        return 'Accessories ';
      default:
        return _departments.contains(oldDepartment)
            ? oldDepartment
            : _departments.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
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
            if (file.path != null) {
              _imageUrls.add(file.path!);
            }
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
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
    _showSnackBar('Product updated successfully!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildStatsRow() {
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
                      value: widget.product.favoriteCount.toString(),
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Total Sales',
                      value: widget.product.salesCount.toString(),
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
                      value: widget.product.viewCount.toString(),
                      icon: Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RatingCard(
                      averageRating: widget.product.averageRating,
                      reviewCount: widget.product.reviewCount,
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
                  value: widget.product.favoriteCount.toString(),
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Total Sales',
                  value: widget.product.salesCount.toString(),
                  icon: Icons.shopping_cart,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Page Views',
                  value: widget.product.viewCount.toString(),
                  icon: Icons.visibility,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: RatingCard(
                  averageRating: widget.product.averageRating,
                  reviewCount: widget.product.reviewCount,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildMainContent() {
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
            selectedCategory: _selectedCategory,
            selectedDepartment: _selectedDepartment,
            selectedGender: _selectedGender,
            categories: _categories,
            departments: _departments,
            genders: _genders,
            onCategoryChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
            onDepartmentChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedDepartment = value;
                });
              }
            },
            onGenderChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedGender = value;
                });
              }
            },
            isMobile: isMobile,
          ),
        );

        Widget productImagesCard = DashboardCard(
          title: 'Product Images',
          child: ImageGallery(
            imageUrls: _imageUrls,
            onPickImages: _pickMultipleImages,
            onRemoveImage: _removeImage,
          ),
        );

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
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: _saveProduct,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildStatsRow(),
            const SizedBox(height: 20),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }
}

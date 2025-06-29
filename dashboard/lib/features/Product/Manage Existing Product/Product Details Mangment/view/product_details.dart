import 'package:dashboard/core/theme.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/product_details_view.dart';
import 'package:flutter/foundation.dart';
import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_mangment_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_managment_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
    _imagesToKeep = List.from(product.images); // Make a mutable copy
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
                    backgroundColor: Themes.primary,
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

          return ProductDetailsView(
            product: product,
            nameController: _nameController,
            descriptionController: _descriptionController,
            priceController: _priceController,
            discountPriceController: _discountPriceController,
            quantityController: _quantityController,
            colorController: _colorController,
            selectedType: _selectedType,
            selectedDepartment: _selectedDepartment,
            selectedGender: _selectedGender,
            selectedAppearance: _selectedAppearance,
            types: _types,
            departments: _departments,
            genders: _genders,
            appearances: _appearances,
            imagesToKeep: _imagesToKeep,
            originalImages: _originalImages,
            newImages: _newImages,
            newImageBytes: _newImageBytes,
            onTypeChanged: (value) {
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
            onPickMultipleImages: _pickMultipleImages,
            onRemoveExistingImage: _removeExistingImage,
            onRemoveNewImage: _removeNewImage,
            onRestoreImage: _restoreImage,
            onRestoreAllImages: _restoreAllImages,
          );
        },
      ),
    );
  }
}

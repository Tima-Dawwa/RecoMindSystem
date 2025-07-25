import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/action_button.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/basic_info_form.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/category_classification.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/color_selection.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/product_image_section.dart';
import 'package:dashboard/features/Product/Add%20Product/view/Widget/product_summary_card.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/cubit/add_product_cubit.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/cubit/add_product_cubit_states.dart';
import 'package:dashboard/features/Product/Add%20Product/Model/product_add.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  List<PlatformFile> _productFiles = [];
  List<String> _imageNames = [];
  String? _selectedCategory;
  String? _selectedGender;
  String? _selectedDepartment;
  String? _selectedApperance;
  List<String> _selectedColors = [];

  void _onImagesUpdated(List<PlatformFile> files, List<String> names) {
    setState(() {
      _productFiles = files;
      _imageNames = names;
    });
  }

  void _onImageRemoved(int index) {
    setState(() {
      _productFiles.removeAt(index);
      _imageNames.removeAt(index);
    });
  }

  void _onColorsChanged(List<String> colors) {
    setState(() {
      _selectedColors = colors;
    });
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onGenderChanged(String? gender) {
    setState(() {
      _selectedGender = gender;
      print(gender);
    });
  }

  void _onDepartmentChanged(String? department) {
    setState(() {
      _selectedDepartment = department;
    });
  }

  void _onApperanceChanged(String? department) {
    setState(() {
      _selectedApperance = department;
    });
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // Validate required fields
      if (_selectedCategory == null ||
          _selectedGender == null ||
          _selectedDepartment == null ||
          _selectedApperance == null ||
          _selectedColors.isEmpty ||
          _productFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill in all required fields and select at least one image and color',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      List<dynamic> imageFiles;

      if (kIsWeb) {
        imageFiles = _productFiles;
      } else {
        imageFiles =
            _productFiles.map((platformFile) {
              return File(platformFile.path!);
            }).toList();
      }

      final productData = ProductFormData(
        name: _nameController.text.trim(),
        details: _descriptionController.text.trim(),
        type: _selectedCategory!,
        department: _selectedDepartment!,
        color: _selectedColors.join(','),
        gender: _selectedGender!,
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
        appearance: _selectedApperance!,
        images: imageFiles,
      );

      context.read<AddProductCubit>().addProduct(productData);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _quantityController.clear();
      _productFiles.clear();
      _imageNames.clear();
      _selectedCategory = null;
      _selectedGender = null;
      _selectedDepartment = null;
      _selectedApperance = null;
      _selectedColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.bg,
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is SuccessAddProduct) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _resetForm();
          } else if (state is FailureAddProduct) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AddProductCubit, AddProductState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Product',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Themes.text,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fill in the details below to add a new product to your inventory',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 32),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWideScreen = constraints.maxWidth > 800;

                        if (isWideScreen) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 1, child: _buildLeftColumn()),
                              SizedBox(width: 8),
                              Expanded(flex: 1, child: _buildRightColumn()),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildLeftColumn(),
                              SizedBox(height: 18),
                              _buildRightColumn(),
                            ],
                          );
                        }
                      },
                    ),

                    SizedBox(height: 18),

                    if (state is LoadingAddProduct)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    ActionButtons(onSave: _saveProduct, onReset: _resetForm),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageSection(
          productFiles: _productFiles,
          imageNames: _imageNames,
          onImagesUpdated: _onImagesUpdated,
          onImageRemoved: _onImageRemoved,
        ),
        SizedBox(height: 24),
        BasicInformationForm(
          nameController: _nameController,
          priceController: _priceController,
          descriptionController: _descriptionController,
          quantityController: _quantityController,
        ),
        SizedBox(height: 24),
        ColorSelectionWidget(
          selectedColors: _selectedColors,
          onColorsChanged: _onColorsChanged,
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        CategoryClassificationForm(
          selectedCategory: _selectedCategory,
          selectedGender: _selectedGender,
          selectedDepartment: _selectedDepartment,
          selectedAppearance: _selectedApperance,
          onCategoryChanged: _onCategoryChanged,
          onGenderChanged: _onGenderChanged,
          onDepartmentChanged: _onDepartmentChanged,
          onApperanceChanged: _onApperanceChanged,
        ),
        SizedBox(height: 18),
        ProductSummaryCard(
          imageCount: _productFiles.length,
          selectedCategory: _selectedCategory,
          selectedGender: _selectedGender,
          selectedDepartment: _selectedDepartment,
          colorCount: _selectedColors.length,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}

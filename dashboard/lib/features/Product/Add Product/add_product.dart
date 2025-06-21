import 'package:dashboard/features/Product/Add%20Product/Widget/action_button.dart';
import 'package:dashboard/features/Product/Add%20Product/Widget/basic_info_form.dart';
import 'package:dashboard/features/Product/Add%20Product/Widget/category_classification.dart';
import 'package:dashboard/features/Product/Add%20Product/Widget/color_selection.dart';
import 'package:dashboard/features/Product/Add%20Product/Widget/product_image_section.dart';
import 'package:dashboard/features/Product/Add%20Product/Widget/product_summary_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/core/theme.dart';


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
    });
  }

  void _onDepartmentChanged(String? department) {
    setState(() {
      _selectedDepartment = department;
    });
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _productFiles.clear();
      _imageNames.clear();
      _selectedCategory = null;
      _selectedGender = null;
      _selectedDepartment = null;
      _selectedColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
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
                        // Left Column
                        Expanded(flex: 2, child: _buildLeftColumn()),
                        SizedBox(width: 32),
                        // Right Column
                        Expanded(flex: 1, child: _buildRightColumn()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildLeftColumn(),
                        SizedBox(height: 24),
                        _buildRightColumn(),
                      ],
                    );
                  }
                },
              ),

              SizedBox(height: 32),

              ActionButtons(onSave: _saveProduct, onReset: _resetForm),
            ],
          ),
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
          onCategoryChanged: _onCategoryChanged,
          onGenderChanged: _onGenderChanged,
          onDepartmentChanged: _onDepartmentChanged,
        ),
        SizedBox(height: 24),
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

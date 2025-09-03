import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/form_component.dart'
    as custom_form;
import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final TextEditingController colorController;
  final TextEditingController quantityController;
  final String selectedCategory;
  final String selectedDepartment;
  final String selectedGender;
  final String selectedAppearance;
  final List<String> categories;
  final List<String> departments;
  final List<String> genders;
  final List<String> appearances;
  final Function(String?) onCategoryChanged;
  final Function(String?) onDepartmentChanged;
  final Function(String?) onGenderChanged;
  final Function(String?) onAppearanceChanged;
  final bool isMobile;

  const ProductForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.discountPriceController,
    required this.colorController,
    required this.quantityController, 
    required this.selectedCategory,
    required this.selectedDepartment,
    required this.selectedGender,
    required this.selectedAppearance,
    required this.categories,
    required this.departments,
    required this.genders,
    required this.appearances,
    required this.onCategoryChanged,
    required this.onDepartmentChanged,
    required this.onGenderChanged,
    required this.onAppearanceChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          // Product Name
          custom_form.FormField(
            label: 'Product Name',
            child: custom_form.CustomTextField(
              controller: nameController,
              label: 'Product Name',
            ),
          ),
          const SizedBox(height: 16),

          // Description
          custom_form.FormField(
            label: 'Description',
            child: custom_form.CustomTextField(
              controller: descriptionController,
              label: 'Description',
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),

          // Price and Discount Price
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Price',
                  child: custom_form.CustomTextField(
                    controller: priceController,
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: custom_form.FormField(
                  label: 'Discount Price',
                  child: custom_form.CustomTextField(
                    controller: discountPriceController,
                    label: 'Discount Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quantity and Color
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Quantity',
                  child: custom_form.CustomTextField(
                    controller: quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: custom_form.FormField(
                  label: 'Color',
                  child: custom_form.CustomTextField(
                    controller: colorController,
                    label: 'Color',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          custom_form.FormField(
            label: 'Category',
            child: custom_form.CustomDropdown<String>(
              value: selectedCategory,
              items: categories,
              label: 'Category',
              onChanged: onCategoryChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Department Dropdown
          custom_form.FormField(
            label: 'Department',
            child: custom_form.CustomDropdown<String>(
              value: selectedDepartment,
              items: departments,
              label: 'Department',
              onChanged: onDepartmentChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Gender Dropdown
          custom_form.FormField(
            label: 'Gender',
            child: custom_form.CustomDropdown<String>(
              value: selectedGender,
              items: genders,
              label: 'Gender',
              onChanged: onGenderChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Appearance Dropdown
          custom_form.FormField(
            label: 'Appearance',
            child: custom_form.CustomDropdown<String>(
              value: selectedAppearance,
              items: appearances,
              label: 'Appearance',
              onChanged: onAppearanceChanged,
            ),
          ),
        ],
      );
    } else {
      // Desktop/tablet layout
      return Column(
        children: [
          // Product Name
          custom_form.FormField(
            label: 'Product Name',
            child: custom_form.CustomTextField(
              controller: nameController,
              label: 'Product Name',
            ),
          ),
          const SizedBox(height: 20),

          // Description
          custom_form.FormField(
            label: 'Description',
            child: custom_form.CustomTextField(
              controller: descriptionController,
              label: 'Description',
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 20),

          // Price Row
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Price',
                  child: custom_form.CustomTextField(
                    controller: priceController,
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: custom_form.FormField(
                  label: 'Discount Price',
                  child: custom_form.CustomTextField(
                    controller: discountPriceController,
                    label: 'Discount Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quantity and Color Row
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Quantity',
                  child: custom_form.CustomTextField(
                    controller: quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: custom_form.FormField(
                  label: 'Color',
                  child: custom_form.CustomTextField(
                    controller: colorController,
                    label: 'Color',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dropdowns Row 1
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Category',
                  child: custom_form.CustomDropdown<String>(
                    value: selectedCategory,
                    items: categories,
                    label: 'Category',
                    onChanged: onCategoryChanged,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: custom_form.FormField(
                  label: 'Department',
                  child: custom_form.CustomDropdown<String>(
                    value: selectedDepartment,
                    items: departments,
                    label: 'Department',
                    onChanged: onDepartmentChanged,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dropdowns Row 2
          Row(
            children: [
              Expanded(
                child: custom_form.FormField(
                  label: 'Gender',
                  child: custom_form.CustomDropdown<String>(
                    value: selectedGender,
                    items: genders,
                    label: 'Gender',
                    onChanged: onGenderChanged,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: custom_form.FormField(
                  label: 'Appearance',
                  child: custom_form.CustomDropdown<String>(
                    value: selectedAppearance,
                    items: appearances,
                    label: 'Appearance',
                    onChanged: onAppearanceChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/widgets/form_component.dart';
import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final TextEditingController colorController;
  final String selectedCategory;
  final String selectedDepartment;
  final String selectedGender;
  final List<String> categories;
  final List<String> departments;
  final List<String> genders;
  final Function(String?) onCategoryChanged;
  final Function(String?) onDepartmentChanged;
  final Function(String?) onGenderChanged;
  final bool isMobile;

  const ProductForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.discountPriceController,
    required this.colorController,
    required this.selectedCategory,
    required this.selectedDepartment,
    required this.selectedGender,
    required this.categories,
    required this.departments,
    required this.genders,
    required this.onCategoryChanged,
    required this.onDepartmentChanged,
    required this.onGenderChanged,
    required this.isMobile,
  });

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isMobile
            ? Column(
              children: [
                _buildFormField(
                  label: 'Product Name',
                  child: CustomTextField(
                    controller: nameController,
                    label: 'Product Name',
                  ),
                ),
                const SizedBox(height: 20),
                _buildFormField(
                  label: 'Color',
                  child: CustomTextField(
                    controller: colorController,
                    label: 'Color',
                  ),
                ),
              ],
            )
            : Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Product Name',
                    child: CustomTextField(
                      controller: nameController,
                      label: 'Product Name',
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildFormField(
                    label: 'Color',
                    child: CustomTextField(
                      controller: colorController,
                      label: 'Color',
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 15),

        isMobile
            ? Column(
              children: [
                _buildFormField(
                  label: 'Category',
                  child: CustomDropdown<String>(
                    value: selectedCategory,
                    items: categories,
                    label: 'Category',
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(height: 15),
                _buildFormField(
                  label: 'Department',
                  child: CustomDropdown<String>(
                    value: selectedDepartment,
                    items: departments,
                    label: 'Department',
                    onChanged: onDepartmentChanged,
                  ),
                ),
                const SizedBox(height: 15),
                _buildFormField(
                  label: 'Gender',
                  child: CustomDropdown<String>(
                    value: selectedGender,
                    items: genders,
                    label: 'Gender',
                    onChanged: onGenderChanged,
                  ),
                ),
              ],
            )
            : Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Category',
                    child: CustomDropdown<String>(
                      value: selectedCategory,
                      items: categories,
                      label: 'Category',
                      onChanged: onCategoryChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    label: 'Department',
                    child: CustomDropdown<String>(
                      value: selectedDepartment,
                      items: departments,
                      label: 'Department',
                      onChanged: onDepartmentChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    label: 'Gender',
                    child: CustomDropdown<String>(
                      value: selectedGender,
                      items: genders,
                      label: 'Gender',
                      onChanged: onGenderChanged,
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 15),

        isMobile
            ? Column(
              children: [
                _buildFormField(
                  label: 'Regular Price',
                  child: CustomTextField(
                    controller: priceController,
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$ ',
                  ),
                ),
                const SizedBox(height: 20),
                _buildFormField(
                  label: 'Discount Price',
                  child: CustomTextField(
                    controller: discountPriceController,
                    label: 'Discount Price',
                    keyboardType: TextInputType.number,
                    prefix: '\$ ',
                  ),
                ),
              ],
            )
            : Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Regular Price',
                    child: CustomTextField(
                      controller: priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      prefix: '\$ ',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    label: 'Discount Price',
                    child: CustomTextField(
                      controller: discountPriceController,
                      label: 'Discount Price',
                      keyboardType: TextInputType.number,
                      prefix: '\$ ',
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 20),
        _buildFormField(
          label: 'Product Description',
          child: CustomTextField(
            controller: descriptionController,
            label: 'Description',
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'card_wrapper.dart';

class CategoryClassificationForm extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedGender;
  final String? selectedDepartment;
  final Function(String?) onCategoryChanged;
  final Function(String?) onGenderChanged;
  final Function(String?) onDepartmentChanged;

  static const List<String> _categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Beauty',
    'Toys',
    'Automotive',
    'Health',
    'Food & Beverages',
  ];

  static const List<String> _genders = ['Male', 'Female', 'Unisex', 'Kids'];

  static const List<String> _departments = [
    'Fashion',
    'Technology',
    'Home',
    'Sports & Outdoors',
    'Health & Beauty',
    'Books & Media',
    'Toys & Games',
    'Automotive',
    'Food & Grocery',
    'Office Supplies',
  ];

  const CategoryClassificationForm({
    super.key,
    required this.selectedCategory,
    required this.selectedGender,
    required this.selectedDepartment,
    required this.onCategoryChanged,
    required this.onGenderChanged,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      title: 'Category & Classification',
      child: Column(
        children: [
          CategoryDropdown(
            selectedCategory: selectedCategory,
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 16),
          GenderDropdown(
            selectedGender: selectedGender,
            onChanged: onGenderChanged,
          ),
          SizedBox(height: 16),
          DepartmentDropdown(
            selectedDepartment: selectedDepartment,
            onChanged: onDepartmentChanged,
          ),
        ],
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      value: selectedCategory,
      items:
          CategoryClassificationForm._categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}

class GenderDropdown extends StatelessWidget {
  final String? selectedGender;
  final Function(String?) onChanged;

  const GenderDropdown({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.people),
      ),
      value: selectedGender,
      items:
          CategoryClassificationForm._genders.map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a gender';
        }
        return null;
      },
    );
  }
}

class DepartmentDropdown extends StatelessWidget {
  final String? selectedDepartment;
  final Function(String?) onChanged;

  const DepartmentDropdown({
    Key? key,
    required this.selectedDepartment,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Department',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business),
      ),
      value: selectedDepartment,
      items:
          CategoryClassificationForm._departments.map((department) {
            return DropdownMenuItem(value: department, child: Text(department));
          }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a department';
        }
        return null;
      },
    );
  }
}

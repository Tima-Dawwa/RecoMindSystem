import 'package:dashboard/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'card_wrapper.dart';

class CategoryClassificationForm extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedGender;
  final String? selectedDepartment;
  final String? selectedAppearance;
  final Function(String?) onCategoryChanged;
  final Function(String?) onGenderChanged;
  final Function(String?) onDepartmentChanged;
  final Function(String?) onApperanceChanged;

  const CategoryClassificationForm({
    super.key,
    required this.selectedCategory,
    required this.selectedGender,
    required this.selectedDepartment,
    required this.onCategoryChanged,
    required this.onGenderChanged,
    required this.onDepartmentChanged,
    required this.selectedAppearance,
    required this.onApperanceChanged,
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
          SizedBox(height: 16),
          AppearanceDropdown(
            selectedAppearance: selectedAppearance,
            onChanged: onApperanceChanged,
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
          categories.map((category) {
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
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

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
          genders.map((gender) {
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
    super.key,
    required this.selectedDepartment,
    required this.onChanged,
  });

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
          departments.map((department) {
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

class AppearanceDropdown extends StatelessWidget {
  final String? selectedAppearance;
  final Function(String?) onChanged;

  const AppearanceDropdown({
    super.key,
    required this.selectedAppearance,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Appearance',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.visibility),
      ),
      value: selectedAppearance,
      items:
          appearances.map((appearance) {
            return DropdownMenuItem(value: appearance, child: Text(appearance));
          }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select an appearance';
        }
        return null;
      },
    );
  }
}

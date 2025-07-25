import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'card_wrapper.dart';

class BasicInformationForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;

  const BasicInformationForm({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      title: 'Basic Information',
      child: Column(
        children: [
          ProductNameField(controller: nameController),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: PriceField(controller: priceController)),
              SizedBox(width: 16),
              Expanded(child: QuantityField(controller: quantityController)),
            ],
          ),
          SizedBox(height: 16),
          DescriptionField(controller: descriptionController),
        ],
      ),
    );
  }
}

class ProductNameField extends StatelessWidget {
  final TextEditingController controller;

  const ProductNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Product Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.shopping_bag),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product name';
        }
        return null;
      },
    );
  }
}

class PriceField extends StatelessWidget {
  final TextEditingController controller;

  const PriceField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Price (\$)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter price';
        }
        return null;
      },
    );
  }
}

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Quantity',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter quantity';
        }
        return null;
      },
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter description';
        }
        return null;
      },
    );
  }
}

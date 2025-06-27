import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/rating_model.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final String details;
  final String graphic;
  final String gender;
  final String department;
  final String color;
  final List<String> images;
  final int quantity;
  final Ratings ratings;
  final int numFavorites;
  final int numViews;
  final int numSales;
  final String type; // Added missing type field

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.details,
    required this.graphic,
    required this.gender,
    required this.department,
    required this.color,
    required this.images,
    required this.quantity,
    required this.ratings,
    required this.numFavorites,
    required this.numViews,
    required this.numSales,
    required this.type, // Added to constructor
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discounted_price'] as num?)?.toDouble() ?? 0.0,
      details: json['details'] ?? '',
      graphic: json['graphic'] ?? '',
      gender: json['gender'] ?? '',
      department: json['department'] ?? '',
      color: json['color'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      quantity: json['quantity'] ?? 0,
      ratings:
          json['ratings'] != null
              ? Ratings.fromJson(json['ratings'])
              : Ratings(one: 0, two: 0, three: 0, four: 0, five: 0),
      numFavorites: json['num_favorites'] ?? 0,
      numViews: json['num_views'] ?? 0,
      numSales: json['num_sales'] ?? 0,
      type: json['type'] ?? '', // Added type field mapping
    );
  }
}

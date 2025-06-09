import 'package:recomindweb/features/product_details/models/review_model.dart';

class Product {
  final String name;
  final double price;
  final double discountedPrice;
  final bool isDiscounted;
  final String details;
  final String graphic;
  final String gender;
  final String department;
  final String color;
  final List<String> images;
  final bool isNew;
  final bool isTrend;
  final List<Review> reviews;

  Product({
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.details,
    required this.graphic,
    required this.gender,
    required this.department,
    required this.color,
    required this.images,
    required this.isNew,
    required this.isTrend,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      isDiscounted: json['is_discounted'],
      details: json['details'],
      graphic: json['graphic'],
      gender: json['gender'],
      department: json['department'],
      color: json['color'],
      images: List<String>.from(json['images']),
      isNew: json['isNew'],
      isTrend: json['isTrend'],
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
    );
  }
}

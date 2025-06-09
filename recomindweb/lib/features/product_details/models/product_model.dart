import 'package:recomindweb/features/product_details/models/review_model.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final bool isfavorite;
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
    required this.id,
    required this.name,
    required this.price,
    required this.isfavorite,
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
      id:json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      isfavorite: json['isFavorite'] as bool,
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      isDiscounted: json['is_discounted'],
      details: json['details'],
      graphic: json['graphic'],
      gender: json['gender'],
      department: json['department'],
      color: json['color'],
      images: List<String>.from(json['images']),
      isNew: json['isNew'] as bool,
      isTrend: json['isTrend'] as bool,
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
    );
  }
}

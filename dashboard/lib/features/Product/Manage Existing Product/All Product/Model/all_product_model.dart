class AllProductModel {
  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final bool isDiscounted;
  final String department;
  final String gender;
  final double rating;
  final bool isNew;
  final bool isTrend;
  final String image;
  final int quantity;

  AllProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.department,
    required this.gender,
    required this.rating,
    required this.isNew,
    required this.isTrend,
    required this.image,
    required this.quantity,
  });

  factory AllProductModel.fromJson(Map<String, dynamic> json) {
    return AllProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Product',
      price: _parseDouble(json['price']),
      discountedPrice: _parseDouble(json['discounted_price']),
      isDiscounted: json['is_discounted'] == true,
      department: json['department']?.toString() ?? 'general',
      gender: json['gender']?.toString() ?? 'unisex',
      rating: _parseDouble(json['rating']),
      isNew: json['isNew'] == true,
      isTrend: json['isTrend'] == true,
      image: json['image']?.toString() ?? '',
      quantity: _parseInt(json['quantity']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Helper method to safely parse int values
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discounted_price': discountedPrice,
      'is_discounted': isDiscounted,
      'department': department,
      'gender': gender,
      'rating': rating,
      'isNew': isNew,
      'isTrend': isTrend,
      'image': image,
      'quantity': quantity,
    };
  }
}

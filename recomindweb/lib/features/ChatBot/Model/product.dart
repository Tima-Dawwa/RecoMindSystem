class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int? discountPercent;
  final bool isFavorite;
  final String gender;
  final String category;
  final bool isTrending;
  final double rating;
  final String tagType;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPercent,
    required this.isFavorite,
    required this.gender,
    required this.category,
    required this.isTrending,
    required this.rating,
    required this.tagType,
  });

  double get discountedPrice {
    if (discountPercent == null) return price;
    return price * (1 - discountPercent! / 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'discountPercent': discountPercent,
      'isFavorite': isFavorite,
      'gender': gender,
      'category': category,
      'isTrending': isTrending,
      'rating': rating,
      'tagType': tagType,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercent: json['discountPercent']?.toInt(),
      isFavorite: json['isFavorite'] ?? false,
      gender: json['gender'] ?? '',
      category: json['category'] ?? '',
      isTrending: json['isTrending'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      tagType: json['tagType'] ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? discountPercent,
    bool? isFavorite,
    String? gender,
    String? category,
    bool? isTrending,
    double? rating,
    String? tagType,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discountPercent: discountPercent ?? this.discountPercent,
      isFavorite: isFavorite ?? this.isFavorite,
      gender: gender ?? this.gender,
      category: category ?? this.category,
      isTrending: isTrending ?? this.isTrending,
      rating: rating ?? this.rating,
      tagType: tagType ?? this.tagType,
    );
  }
}

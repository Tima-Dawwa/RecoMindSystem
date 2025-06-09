class Recommendation {
  final String id;
  final String parentId;
  final String name;
  final String image;
  final double price;
  final bool isfavorite;
  final double discountedPrice;
  final bool isDiscounted;
  final String department;
  final double rating;
  final String gender;
  final bool isNew;
  final bool isTrend;

  Recommendation({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.department,
    required this.rating,
    required this.gender,
    required this.isNew,
    required this.isTrend,
    required this.isfavorite,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      isfavorite: json['isFavorite'] as bool,
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      isDiscounted: json['is_discounted'],
      department: json['department'],
      rating: (json['rating'] as num).toDouble(),
      gender: json['gender'] ,
      isNew: json['isNew'] as bool,
      isTrend: json['isTrend'] as bool,
    );
  }
}

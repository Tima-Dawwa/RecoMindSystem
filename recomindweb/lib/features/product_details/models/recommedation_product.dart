class Recommendation {
  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final bool isDiscounted;
  final String department;
  final double rating;
  final bool isNew;
  final bool isTrend;

  Recommendation({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.department,
    required this.rating,
    required this.isNew,
    required this.isTrend,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      isDiscounted: json['is_discounted'],
      department: json['department'],
      rating: (json['rating'] as num).toDouble(),
      isNew: json['isNew'],
      isTrend: json['isTrend'],
    );
  }
}

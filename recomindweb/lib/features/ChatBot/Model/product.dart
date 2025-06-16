class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double? discountPercent;
  final bool isFavorite;
  final String gender;
  final String category;
  final bool isTrending;
  final double rating;
  final String? tagType; // values like: 'TREND', 'NEW', 'SALE'


  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPercent,
    this.isFavorite = false,
    required this.gender,
    required this.category,
    this.isTrending = false,
    this.rating = 0.0,
    this.tagType ,
  });
}

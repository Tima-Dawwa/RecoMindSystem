class Product {
  String id;
  String name;
  String category;
  String department;
  String gender;
  double price;
  double? discountPrice;
  String description;
  List<String> imageUrls;
  String color;
  int favoriteCount;
  int salesCount;
  int viewCount;
  double averageRating;
  int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.department,
    required this.gender,
    required this.price,
    this.discountPrice,
    required this.description,
    required this.imageUrls,
    required this.color,
    this.favoriteCount = 0,
    this.salesCount = 0,
    this.viewCount = 0,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });
}

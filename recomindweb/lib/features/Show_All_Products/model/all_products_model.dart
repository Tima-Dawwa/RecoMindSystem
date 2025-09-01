class AllProductsModel {
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
  final bool isFav;
  final String urlImage;

  AllProductsModel({
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
    required this.isFav,
    required this.urlImage,
  });

  factory AllProductsModel.fromjson(jsonData) {
    return AllProductsModel(
      id: jsonData['id'],
      name: jsonData['name'],
      price: jsonData['price'],
      discountedPrice: jsonData['discounted_price'],
      isDiscounted: jsonData['is_discounted'],
      department: jsonData['department'],
      gender: jsonData['gender'],
      rating: jsonData['rating'],
      isNew: jsonData['isNew'],
      isTrend: jsonData['isTrend'],
      isFav: jsonData['isFavorite'],
      urlImage: jsonData['image'],
    );
  }
}

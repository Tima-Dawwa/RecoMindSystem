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

  AllProductsModel copyWith({
    String? id,
    String? name,
    double? price,
    double? discountedPrice,
    bool? isDiscounted,
    String? department,
    String? gender,
    double? rating,
    bool? isNew,
    bool? isTrend,
    bool? isFav,
    String? urlImage,
  }) {
    return AllProductsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      department: department ?? this.department,
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      isNew: isNew ?? this.isNew,
      isTrend: isTrend ?? this.isTrend,
      isFav: isFav ?? this.isFav,
      urlImage: urlImage ?? this.urlImage,
    );
  }
}

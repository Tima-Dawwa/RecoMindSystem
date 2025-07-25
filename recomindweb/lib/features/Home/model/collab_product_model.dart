class CollabProductModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final num price;
  final num discount;
  final num rating;
  final num ratingCount;
  final bool isNew;

  CollabProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.discount,
    required this.isNew,
    required this.rating,
    required this.ratingCount,
  });

  factory CollabProductModel.fromJson(jsonData) {
    return CollabProductModel(
      id: jsonData['_id'],
      name: jsonData['name'],
      image: jsonData['images'][0],
      price: jsonData['price'],
      discount: jsonData['discounted_price'],
      category: jsonData['type'],
      isNew: jsonData['isNew'],
      rating: jsonData["rating"],
      ratingCount: jsonData["rating_count"],
    );
  }
}

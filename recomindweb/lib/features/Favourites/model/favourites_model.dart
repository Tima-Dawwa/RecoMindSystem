class FavouritesModel {
  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final bool isDiscounted;
  final String department;
  final bool isNew;
   final String image;

  FavouritesModel( {
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.department,
    required this.isNew,
     required this.image
  });

  factory FavouritesModel.fromjson(jsonData) {
    return FavouritesModel(
      id: jsonData['id'],
      name: jsonData['name'],
      price: jsonData['price'],
      discountedPrice: jsonData['discounted_price'],
      isDiscounted: jsonData['is_discounted'],
      department: jsonData['department'],
      isNew: jsonData['isNew'],
       image: jsonData['image']
    );
  }
}

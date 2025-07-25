class ProductModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final int quantity;
  final int price;

  ProductModel({
    required this.category,
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory ProductModel.fromJson(jsonData) {
    return ProductModel(
      id: jsonData['id'],
      name: jsonData['name'],
      image: jsonData['image'],
      quantity: jsonData['quantity'],
      price: jsonData['discounted_price'],
      category: jsonData['department'],
    );
  }
}

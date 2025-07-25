
class CartModel {
  final String id;
  final String name;
  final String department;
  final String image;
  final double price;
  late final int quantity;
  final String color;

  CartModel({
    required this.id,
    required this.name,
    required this.department,
    required this.image,
    required this.price,
    required this.quantity,
    required this.color,
  });

    factory CartModel.fromJson(jsonData) {
    return CartModel(
      id: jsonData['id'],
      name: jsonData['name'],
      department: jsonData['department'],
      image: jsonData['image'],
      price: jsonData['price'],
      quantity: jsonData['quantity'],
      color: jsonData['color'],
    );
  }
}

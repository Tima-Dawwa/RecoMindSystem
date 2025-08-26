class CartModel {
  final String id;
  final String name;
  final String department;
  final String image;
  final double price;
  final int quantity;
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

  CartModel copyWith({
    String? id,
    String? name,
    String? department,
    String? image,
    double? price,
    int? quantity,
    String? color,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
    );
  }
}

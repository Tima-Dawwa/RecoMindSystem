
class ProductFormData {
  final String name;
  final String details;
  final String type;
  final String department;
  final String color;
  final String gender;
  final double price;
  final int quantity;
  final String appearance;
  final List<dynamic> images; 

  ProductFormData({
    required this.name,
    required this.details,
    required this.type,
    required this.department,
    required this.color,
    required this.gender,
    required this.price,
    required this.quantity,
    required this.appearance,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'type': type,
      'department': department,
      'color': color,
      'gender': gender,
      'price': price,
      'quantity': quantity,
      'appearance': appearance,
    };
  }
}

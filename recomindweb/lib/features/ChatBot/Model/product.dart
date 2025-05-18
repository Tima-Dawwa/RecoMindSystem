class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double? discountPercent;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPercent,
  });
}

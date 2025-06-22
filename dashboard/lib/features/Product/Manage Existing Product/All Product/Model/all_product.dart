class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String status;
  final String category;
  final int amount; // Added amount field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.status,
    required this.category,
    required this.amount, // Required amount parameter
  });

  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    double? rating,
    String? status,
    String? category,
    int? amount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }
}

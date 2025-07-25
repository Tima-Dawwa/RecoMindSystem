class Review {
  final String name;
  final int rating;
  final String? review;
  final String createdAt;

  Review({
    required this.name,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
    );
  }
}

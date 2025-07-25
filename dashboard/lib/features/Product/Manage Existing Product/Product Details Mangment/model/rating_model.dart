class Ratings {
  final int one;
  final int two;
  final int three;
  final int four;
  final int five;

  Ratings({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      one: json['1'] ?? 0,
      two: json['2'] ?? 0,
      three: json['3'] ?? 0,
      four: json['4'] ?? 0,
      five: json['5'] ?? 0,
    );
  }

  // Calculate average rating
  double get averageRating {
    int totalRatings = count;
    if (totalRatings == 0) return 0.0;

    int totalPoints =
        (one * 1) + (two * 2) + (three * 3) + (four * 4) + (five * 5);
    return totalPoints / totalRatings;
  }

  // Get total count of all ratings
  int get count {
    return one + two + three + four + five;
  }
}

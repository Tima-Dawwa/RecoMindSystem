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
      one: json['1'],
      two: json['2'],
      three: json['3'],
      four: json['4'],
      five: json['5'],
    );
  }
}

class InteractionsModel {
  final int interactions;
  final String name;

  InteractionsModel({required this.interactions, required this.name});

  factory InteractionsModel.fromJson(jsonData) {
    return InteractionsModel(
      interactions: jsonData['interaction_count'],
      name: jsonData['full_name'],
    );
  }
}

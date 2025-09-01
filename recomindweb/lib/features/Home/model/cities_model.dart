class CitiesModel {
  final String country;
  final List<String> cities;

  CitiesModel({required this.country, required this.cities});

  factory CitiesModel.fromJson(jsonData) {
    return CitiesModel(
        country: jsonData["name"],
        cities: List<String>.from(jsonData['cities']));
  }
}

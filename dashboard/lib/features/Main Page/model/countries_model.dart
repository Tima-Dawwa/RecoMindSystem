class CountriesModel {
  final int users;
  final String country;

  CountriesModel({required this.country, required this.users});

  factory CountriesModel.fromJson(jsonData) {
    return CountriesModel(
      users: jsonData['userCount'],
      country: jsonData['country'],
    );
  }
}

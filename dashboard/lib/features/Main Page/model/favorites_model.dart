class FavoritesModel {
  final String name;
  final int favorites;

  FavoritesModel({required this.favorites, required this.name});

  factory FavoritesModel.fromJson(jsonData) {
    return FavoritesModel(name: jsonData['name'], favorites: jsonData['favoritesCount']);
  }
}

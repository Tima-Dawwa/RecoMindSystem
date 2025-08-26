import 'package:recomindweb/core/helpers/failure.dart';

class FavouritesState {}

class FavouritesInitialState extends FavouritesState {}

class FavouritesLoadingState extends FavouritesState {}

class FavouritesSuccessState extends FavouritesState {}

class FavouritesFailureState extends FavouritesState {
  final Failure failure;
  FavouritesFailureState({required this.failure});
}

class RemoveFavouritesLoadingState extends FavouritesState {}


class RemoveFavouritesSuccessState extends FavouritesState {
  final String message;
  RemoveFavouritesSuccessState({required this.message});
}

class RemoveFavouritesFailureState extends FavouritesState {
  final Failure failure;
  RemoveFavouritesFailureState({required this.failure});
}

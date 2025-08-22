import 'package:recomindweb/core/helpers/failure.dart';

class FavouritesState {}

class FavouritesInitialState extends FavouritesState {}

class FavouritesLoadingState extends FavouritesState {}

class FavouritesSuccessState extends FavouritesState {}

class FavouritesFailureState extends FavouritesState {
  final Failure failure;
  FavouritesFailureState({required this.failure});
}

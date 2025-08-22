import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_state.dart';
import 'package:recomindweb/features/Favourites/view%20model/favourites_service.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  final FavouritesService favouritesService;
  FavouritesCubit(this.favouritesService) : super(FavouritesInitialState());

  List FavouritesItems = [];

  Future<void> getFavourites() async {
    emit(FavouritesState());
    var response = await favouritesService.getFavourites();
    response.fold(
      (failure) {
        emit(FavouritesFailureState(failure: failure));
      },
      (res) {
        // cartItems = [];
        // for (var i = 0; i < res['data'].length; i++) {
        //   cartItems.add(CartModel.fromJson(res["data"][i]));
        // }
        emit(FavouritesSuccessState());
      },
    );
  }

  Future<void> removeFromFavourites(String id) async {
    emit(FavouritesState());
    var response = await favouritesService.removeFromFavourites(id);
    response.fold(
      (failure) {
        emit(FavouritesFailureState(failure: failure));
      },
      (res) {
        // cartItems = [];
        // for (var i = 0; i < res['data'].length; i++) {
        //   cartItems.add(CartModel.fromJson(res["data"][i]));
        // }
        emit(FavouritesSuccessState());
      },
    );
  }
}

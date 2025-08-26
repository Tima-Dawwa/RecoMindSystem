import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Favourites/model/favourites_model.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_state.dart';
import 'package:recomindweb/features/Favourites/view%20model/favourites_service.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  final FavouritesService favouritesService;
  FavouritesCubit(this.favouritesService) : super(FavouritesInitialState());

  List<FavouritesModel> favouritesItems = [];
  String? messageDeleted;

  Future<void> getFavourites() async {
    emit(FavouritesLoadingState());
    var response = await favouritesService.getFavourites();
    response.fold(
      (failure) {
        emit(FavouritesFailureState(failure: failure));
      },
      (res) {
        favouritesItems = [];
        for (var i = 0; i < res['data'].length; i++) {
          favouritesItems.add(FavouritesModel.fromjson(res['data'][i]));
        }
        emit(FavouritesSuccessState());
      },
    );
  }

  Future<void> removeFromFavourites({required String id}) async {
    emit(RemoveFavouritesLoadingState());
    await Future.delayed(const Duration(milliseconds: 5));
    var response = await favouritesService.removeFromFavourites(id);
    response.fold(
      (failure) {
        emit(RemoveFavouritesFailureState(failure: failure));
      },
      (res) {
        messageDeleted = res['message'];
        favouritesItems.removeWhere((item) => item.id == id);
        emit(RemoveFavouritesSuccessState(message: messageDeleted!));
      },
    );
  }
}

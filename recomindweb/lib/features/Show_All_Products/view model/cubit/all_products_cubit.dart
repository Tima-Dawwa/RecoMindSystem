import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/all_products_service.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState>{
  final AllProductsService allProductsService;
  AllProductsCubit(this.allProductsService) : super(AllProductsInitialState());

   Future<void> getCart() async {
    emit(AllProductsLoadingState());
    var response = await allProductsService.getAllProducts(limit, page);
    response.fold(
      (failure) {
        emit(AllProductsFailureState(failure: failure));
      },
      (res) {
        // cartItems = [];
        // for (var i = 0; i < res['data'].length; i++) {
        //   cartItems.add(CartModel.fromJson(res["data"][i]));
        // }
        emit(AllProductsSuccessState());
      },
    );
  }
}
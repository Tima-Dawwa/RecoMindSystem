import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/all_products_service.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  final AllProductsService allProductsService;
  AllProductsCubit(this.allProductsService) : super(AllProductsInitialState());

  List<AllProductsModel> allProducts = [];

  Future<void> getAllProducts({
    int? page,
    String? type,
    double? maxPrice,
    double? minPrice,
    bool? isNew,
    bool? isTrend,
  }) async {
    emit(AllProductsLoadingState());
    var response = await allProductsService.getAllProducts(
      limit: 15,
      page: page,
      type: type,
      maxPrice: maxPrice,
      minPrice: minPrice,
      isNew: isNew,
      isTrend: isTrend,
    );
    response.fold(
      (failure) {
        emit(AllProductsFailureState(failure: failure));
      },
      (res) {
        for (var i = 0; i < res['data'].length; i++) {
          allProducts.add(AllProductsModel.fromjson(res["data"][i]));
        }
        emit(AllProductsSuccessState());
      },
    );
  }
}

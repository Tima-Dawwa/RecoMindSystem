import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/all_products_service.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  final AllProductsService allProductsService;
  AllProductsCubit(this.allProductsService) : super(AllProductsInitialState());

  List<AllProductsModel> allProducts = [];
  int countAllProducts = 0;
  bool searchText = true;

  int? currentPage;
  String? currentType;
  double? currentMinPrice;
  double? currentMaxPrice;
  bool? currentIsNew;
  bool? currentIsTrend;
  List<String> selectedCategories = [];

  Future<void> getAllProducts({
    String textSearch = '',
    x = 1,
    int? page,
    String? type,
    double? maxPrice,
    double? minPrice,
    bool? isNew,
    bool? isTrend,
    List<String>? categories,
  }) async {
    if (x == 1) {
      currentPage = page ?? currentPage ?? 1;
      currentType = type ?? currentType;
      currentMinPrice = minPrice ?? currentMinPrice;
      currentMaxPrice = maxPrice ?? currentMaxPrice;
      if (categories != null) selectedCategories = categories;

      emit(AllProductsLoadingState());
      var response = await allProductsService.getAllProducts(
        limit: 50,
        page: page,
        type: type,
        maxPrice: maxPrice,
        minPrice: minPrice,
        isNew: isNew,
        isTrend: isTrend,
      );
      response.fold(
        (failure) {
          print("----------${failure.errMessage}");
          emit(AllProductsFailureState(failure: failure));
        },
        (res) {
          allProducts.clear();

          for (var i = 0; i < res['data'].length; i++) {
            allProducts.add(AllProductsModel.fromjson(res["data"][i]));
          }
          countAllProducts = res['count'];
          emit(AllProductsSuccessState());
        },
      );
    } else {
      smartSearch(textSearch);
    }
  }

  void applyFilter() {
    emit(AllProductsFilterState());
  }

  void resetFilters() {
    currentPage = 1;
    currentType = null;
    currentMinPrice = null;
    currentMaxPrice = null;
    currentIsNew = null;
    currentIsTrend = null;
    selectedCategories.clear();

    emit(AllProductsInitialState());
  }

  Future<void> smartSearch(String text) async {
    searchText = false;
    print("ءءءءءءءءءءء$text");
    emit(AllProductsLoadingState());
    var response = await allProductsService.smartSearch(text);
    response.fold(
      (failure) {
        print("----------${failure.errMessage}");
        emit(SmartSearchFailureState(failure: failure));
      },
      (res) {
        allProducts.clear();
        for (var i = 0; i < res['data'].length; i++) {
          allProducts.add(AllProductsModel.fromjson(res["data"][i]));
        }
        countAllProducts = res['count'];
        print("ddddddddd$text");
        emit(AllProductsSuccessState());
        searchText = true;
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/features/product_details/models/product_response.dart';
import 'package:recomindweb/features/product_details/view model/product details cubit/product_details_state.dart';
import 'package:recomindweb/features/product_details/view model/product_details_service.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsService productDetailsService;

  ProductDetailsCubit(this.productDetailsService)
    : super(InitialProductDetails());

  Future<void> fetchProduct({required String productId}) async {
    emit(LoadingProductDetails());
    final result = await productDetailsService.getOneProduct(
      productId: productId,
    );

    result.fold((failure) => emit(FailureProductDetails(failure: failure)), (
      data,
    ) {
      try {
        final productResponse = ProductResponse.fromJson(data);
        emit(SuccessProductDetails(product: productResponse));
      } catch (e) {
        emit(
          FailureProductDetails(
            failure: Failure(
              errTitle: "Parsing Error",
              errMessage: e.toString(),
            ),
          ),
        );
      }
    });
  }

  Future<void> addReview({
    required String productId,
    required int rating,
    String? commit,
  }) async {
    emit(LoadingProductDetails());
    final result = await productDetailsService.addReview(
      productId: productId,
      rating: rating,
      commit: commit ?? "",
    );
    result.fold((failure) => emit(FailureProductDetails(failure: failure)), (
      _,
    ) async {
      await fetchProduct(productId: productId);
    });
  }

  Future<void> addToFavorites(String productId, String parentId) async {
    emit(LoadingProductDetails());
    final result = await productDetailsService.addToFavorites(
      productId: productId,
    );
    result.fold((failure) => emit(FailureProductDetails(failure: failure)), (
      _,
    ) async {
      await fetchProduct(productId: parentId);
    });
  }

  Future<void> deleteFavorite(String productId, String parentId) async {
    emit(LoadingProductDetails());
    final result = await productDetailsService.deleteFavorite(
      favoriteId: productId,
    );
    result.fold((failure) => emit(FailureProductDetails(failure: failure)), (
      _,
    ) async {
      await fetchProduct(productId: parentId);
    });
  }

  Future<void> addToCart({
    required String productId,
    required int count,
  }) async {
    emit(LoadingProductDetails());
    final result = await productDetailsService.addToCart(
      productId: productId,
      count: count,
    );
    result.fold((failure) => emit(FailureProductDetails(failure: failure)), (
      _,
    ) async {
      await fetchProduct(productId: productId);
    });
  }
}

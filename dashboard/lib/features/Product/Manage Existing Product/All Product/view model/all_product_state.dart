import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';

class AllProductState {}

class InitialAllProduct extends AllProductState {}

class LoadingAllProduct extends AllProductState {}

class SuccessAllProduct extends AllProductState {
  final List<AllProductModel> products;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  SuccessAllProduct({
    required this.products,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  SuccessAllProduct copyWith({
    List<AllProductModel>? products,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return SuccessAllProduct(
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FailureAllProduct extends AllProductState {
  final Failure failure;

  FailureAllProduct({required this.failure});
}

class SearchingAllProduct extends AllProductState {}

class SearchSuccessAllProduct extends AllProductState {
  final List<AllProductModel> searchResults;
  final String searchQuery;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  SearchSuccessAllProduct({
    required this.searchResults,
    required this.searchQuery,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

class DeletingAllProduct extends AllProductState {
  final String productId;

  DeletingAllProduct({required this.productId});
}

class DeleteSuccessAllProduct extends AllProductState {
  final String deletedProductId;

  DeleteSuccessAllProduct({required this.deletedProductId});
}

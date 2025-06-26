import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_service.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_state.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

class AllProductCubit extends Cubit<AllProductState> {
  final AllProductService allProductService;
  String? _currentGenderFilter;
  String? _currentNameFilter;
  bool _isLoading = false;

  AllProductCubit(this.allProductService) : super(InitialAllProduct());

  Future<void> getAllProducts({
    int page = 1,
    String? gender,
    String? name,
  }) async {
    if (_isLoading) return;

    _isLoading = true;

    _currentGenderFilter = gender;
    _currentNameFilter = name;

    emit(LoadingAllProduct());

    final result = await allProductService.getAllProducts(
      page: page,
      gender: gender,
      name: name,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        emit(FailureAllProduct(failure: failure));
      },
      (paginatedResponse) {
        emit(
          SuccessAllProduct(
            products: paginatedResponse.products,
            totalCount: paginatedResponse.totalCount,
            currentPage: paginatedResponse.currentPage,
            totalPages: paginatedResponse.totalPages,
            hasMore: paginatedResponse.hasMore,
          ),
        );
      },
    );
  }

  Future<void> searchProducts(String query, {int page = 1}) async {
    if (_isLoading) return;

    if (query.isEmpty) {
      await getAllProducts(page: page);
      return;
    }

    _isLoading = true;
    _currentNameFilter = query;

    emit(SearchingAllProduct());

    final result = await allProductService.searchProducts(
      query: query,
      page: page,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        emit(FailureAllProduct(failure: failure));
      },
      (paginatedResponse) {
        emit(
          SearchSuccessAllProduct(
            searchResults: paginatedResponse.products,
            searchQuery: query,
            totalCount: paginatedResponse.totalCount,
            currentPage: paginatedResponse.currentPage,
            totalPages: paginatedResponse.totalPages,
            hasMore: paginatedResponse.hasMore,
          ),
        );
      },
    );
  }

  Future<void> filterByGender(String? gender, {int page = 1}) async {
    await getAllProducts(page: page, gender: gender, name: _currentNameFilter);
  }

  Future<void> applyFilters({
    String? gender,
    String? name,
    int page = 1,
  }) async {
    await getAllProducts(page: page, gender: gender, name: name);
  }

  Future<void> clearFilters({int page = 1}) async {
    _currentGenderFilter = null;
    _currentNameFilter = null;

    await getAllProducts(page: page);
  }

  Future<void> loadPage(int page) async {
    if (_currentNameFilter != null && _currentNameFilter!.isNotEmpty) {
      await searchProducts(_currentNameFilter!, page: page);
    } else {
      await getAllProducts(
        page: page,
        gender: _currentGenderFilter,
        name: _currentNameFilter,
      );
    }
  }

  Future<void> deleteProduct(String productId, {int currentPage = 1}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      emit(DeletingAllProduct(productId: productId));

      final result = await allProductService.deleteProduct(productId);

      _isLoading = false;

      result.fold(
        (failure) {
          emit(FailureAllProduct(failure: failure));
        },
        (success) {
          if (success) {
            emit(DeleteSuccessAllProduct(deletedProductId: productId));
            loadPage(currentPage);
          } else {
            emit(
              FailureAllProduct(
                failure: Failure(errMessage: 'Failed to delete product'),
              ),
            );
          }
        },
      );
    } catch (e) {
      _isLoading = false;
      emit(FailureAllProduct(failure: Failure(errMessage: e.toString())));
    }
  }

  Future<Either<Failure, AllProductModel?>?> getProductById(String id) async {
    try {
      return await allProductService.getProductById(id);
    } catch (e) {
      emit(FailureAllProduct(failure: Failure(errMessage: e.toString())));
      return null;
    }
  }

  Future<void> refreshProducts({int page = 1}) async {
    await loadPage(page);
  }

  Map<String, String?> getCurrentFilters() {
    return {'gender': _currentGenderFilter, 'name': _currentNameFilter};
  }

  bool hasActiveFilters() {
    return _currentGenderFilter != null ||
        (_currentNameFilter != null && _currentNameFilter!.isNotEmpty);
  }

  bool get isLoading => _isLoading;

  String? get currentGenderFilter => _currentGenderFilter;
  String? get currentNameFilter => _currentNameFilter;
}

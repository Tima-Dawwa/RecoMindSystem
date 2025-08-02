import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PaginatedProductResponse {
  final List<AllProductModel> products;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  PaginatedProductResponse({
    required this.products,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  factory PaginatedProductResponse.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> productsJson =
          json['products'] ??
          json['data'] ??
          json['items'] ??
          (json is List ? json : []);

      final products = <AllProductModel>[];

      for (final productJson in productsJson) {
        try {
          if (productJson is Map<String, dynamic>) {
            products.add(AllProductModel.fromJson(productJson));
          }
        } catch (e) {
          // Skip invalid product data
          continue;
        }
      }

      final totalCount = _parseInt(
        json['total'] ?? json['totalCount'] ?? json['count'] ?? products.length,
      );
      final currentPage = _parseInt(json['currentPage'] ?? json['page'] ?? 1);
      final limit = _parseInt(
        json['limit'] ?? json['pageSize'] ?? json['per_page'] ?? 10,
      );
      final totalPages = totalCount > 0 ? (totalCount / limit).ceil() : 1;
      final hasMore = currentPage < totalPages;

      return PaginatedProductResponse(
        products: products,
        totalCount: totalCount,
        currentPage: currentPage,
        totalPages: totalPages,
        hasMore: hasMore,
      );
    } catch (e) {
      return PaginatedProductResponse(
        products: [],
        totalCount: 0,
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
      );
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class AllProductService {
  final Api api;
  final StatusCodeHandler statusCodeHandler;

  AllProductService(this.api, this.statusCodeHandler);

  Future<Either<Failure, PaginatedProductResponse>> getAllProducts({
    int? page,
    String? name,
    String? gender,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (gender != null && gender.isNotEmpty) queryParams['gender'] = gender;

      final response = await api.get(
        endPoint: '/dashboard/products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final paginatedResponse = PaginatedProductResponse.fromJson(response);
      return Right(paginatedResponse);
    } on DioException catch (e) {
      return Left(Failure.fromDioException(e, statusCodeHandler));
    } catch (e) {
      return Left(
        Failure(
          errTitle: 'Parse Error',
          errMessage: 'Error parsing products response: $e',
        ),
      );
    }
  }

  Future<Either<Failure, AllProductModel?>> getProductById(String id) async {
    try {
      final response = await api.get(endPoint: '/dashboard/products/$id');
      return Right(AllProductModel.fromJson(response));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Right(null);
      }
      return Left(Failure.fromDioException(e, statusCodeHandler));
    } catch (e) {
      return Left(
        Failure(
          errTitle: 'Parse Error',
          errMessage: 'Error parsing product: $e',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> deleteMultipleProducts(List<String> ids) async {
    try {
      await api.delete(endPoint: '/dashboard/products', body: {"ids": ids});
      return const Right(true);
    } on DioException catch (e) {
      return Left(Failure.fromDioException(e, statusCodeHandler));
    } catch (e) {
      return Left(
        Failure(
          errTitle: 'Delete Error',
          errMessage: 'Error deleting products: $e',
        ),
      );
    }
  }

  Future<Either<Failure, PaginatedProductResponse>> searchProducts({
    required String query,
    int? page,
  }) async {
    return getAllProducts(name: query, page: page);
  }

  Future<Either<Failure, PaginatedProductResponse>> getProductsByGender({
    required String gender,
    int? page,
  }) async {
    return getAllProducts(gender: gender, page: page);
  }
}

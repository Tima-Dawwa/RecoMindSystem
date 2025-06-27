import 'package:dartz/dartz.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart';
import 'package:dio/dio.dart';

class ManageProductService {
  final Api api;
  final StatusCodeHandler statusCodeHandler;
  ManageProductService(this.api, this.statusCodeHandler);

  Future<Either<Failure, ProductModel>> getOneProduct({
    required String id,
  }) async {
    try {
      final response = await api.get(endPoint: 'dashboard/products/$id');
      final productData = response['data'];
      final product = ProductModel.fromJson(productData);

      return right(product);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }

  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? details,
    String? type,
    String? department,
    String? color,
    String? gender,
    double? price,
    int? quantity,
    String? appearance,
    List<String>? imagesToKeep,
    List<String>? newImages,
  }) async {
    try {
      final Map<String, dynamic> body = {};

      if (name != null) body['name'] = name;
      if (details != null) body['details'] = details;
      if (type != null) body['type'] = type;
      if (department != null) body['department'] = department;
      if (color != null) body['color'] = color;
      if (gender != null) body['gender'] = gender;
      if (price != null) body['price'] = price.toString();
      if (quantity != null) body['quantity'] = quantity.toString();
      if (appearance != null) body['appearance'] = appearance;

      if (imagesToKeep != null && imagesToKeep.isNotEmpty) {
        for (int i = 0; i < imagesToKeep.length; i++) {
          body['imagesToKeep[$i]'] = imagesToKeep[i];
        }
      }

      if (newImages != null && newImages.isNotEmpty) {
        for (int i = 0; i < newImages.length; i++) {
          body['images[$i]'] = newImages[i];
        }
      }

      final response = await api.put(
        endPoint: 'dashboard/products/$id',
        body: body,
      );

      final productData = response['data'];
      final product = ProductModel.fromJson(productData);

      return right(product);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }
}

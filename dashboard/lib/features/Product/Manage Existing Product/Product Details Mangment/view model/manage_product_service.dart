import 'dart:typed_data';
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
      final response = await api.get(endPoint: '/dashboard/products/$id');
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

  Future<Either<Failure, String>> updateProduct({
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
    double? discountedPrice,
    List<String>? imagesToKeep,
    List<String>? newImages,
    List<Uint8List>? newImageBytes,
  }) async {
    try {
      final FormData formData = FormData();

      if (name != null) formData.fields.add(MapEntry('name', name));
      if (details != null) formData.fields.add(MapEntry('details', details));
      if (type != null) formData.fields.add(MapEntry('type', type));
      if (department != null) {
        formData.fields.add(MapEntry('department', department));
      }
      if (color != null) formData.fields.add(MapEntry('color', color));
      if (gender != null) formData.fields.add(MapEntry('gender', gender));
      if (price != null) {
        formData.fields.add(MapEntry('price', price.toString()));
      }
      if (quantity != null) {
        formData.fields.add(MapEntry('quantity', quantity.toString()));
      }
      if (appearance != null) {
        formData.fields.add(MapEntry('appearance', appearance));
      }
      if (discountedPrice != null) {
        formData.fields.add(
          MapEntry('discounted_price', discountedPrice.toString()),
        );
      }

      if (imagesToKeep != null && imagesToKeep.isNotEmpty) {
        for (int i = 0; i < imagesToKeep.length; i++) {
          formData.fields.add(MapEntry('imagesToKeep[$i]', imagesToKeep[i]));
        }
      }

      if (newImageBytes != null && newImageBytes.isNotEmpty) {
        for (int i = 0; i < newImageBytes.length; i++) {
          formData.files.add(
            MapEntry(
              'images',
              MultipartFile.fromBytes(
                newImageBytes[i],
                filename: 'image_$i.jpg',
              ),
            ),
          );
        }
      } else if (newImages != null && newImages.isNotEmpty) {
        for (int i = 0; i < newImages.length; i++) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                newImages[i],
                filename: 'image_$i.jpg',
              ),
            ),
          );
        }
      }

      final response = await api.put(
        endPoint: '/dashboard/products/$id',
        body: formData,
      );

      final message = response['message'];
      print(message);

      return right(message);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }
}

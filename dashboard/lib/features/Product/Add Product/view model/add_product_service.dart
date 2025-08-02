import 'package:dartz/dartz.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddProductService {
  final Api api;
  String? token;
  final StatusCodeHandler statusCodeHandler;

  AddProductService(this.api, this.statusCodeHandler);

  Future<Either<Failure, Map<String, dynamic>>> addProduct({
    required String name,
    required String details,
    required String type,
    required String department,
    required String color,
    required String gender,
    required double price,
    required int quantity,
    required String appearance,
    required List<dynamic>
    images, 
  }) async {
    try {
      List<MultipartFile> multipartFiles = [];

      for (var image in images) {
        if (kIsWeb) {
          if (image is PlatformFile) {
            multipartFiles.add(
              MultipartFile.fromBytes(image.bytes!, filename: image.name),
            );
          }
        } else {
          if (image is File) {
            multipartFiles.add(
              await MultipartFile.fromFile(
                image.path,
                filename: image.path.split('/').last,
              ),
            );
          } else if (image is PlatformFile) {
            final file = File(image.path!);
            multipartFiles.add(
              await MultipartFile.fromFile(file.path, filename: image.name),
            );
          }
        }
      }

      final formData = FormData.fromMap({
        'name': name,
        'details': details,
        'type': type,
        'department': department,
        'color': color,
        'gender': gender,
        'price': price.toString(),
        'quantity': quantity.toString(),
        'appearance': appearance,
        'images': multipartFiles,
      });

      final response = await api.post(
        endPoint: '/dashboard/products/',
        body: formData,
      );

      return right(response);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class FavouritesService {
  final Api api;

  FavouritesService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getFavourites() async {
    try {
      Map<String, dynamic> response = await api.get(endPoint: '/favorites/');
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(Failure.fromDioException(e, DefaultStatusCodeHandler()));
      } else {
        return left(
          Failure(errMessage: 'something went wrong (not DioException)'),
        );
      }
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> removeFromFavourites(
    String id,
  ) async {
    try {
      Map<String, dynamic> response = await api.delete(
        endPoint: '/favorites/$id',
        body: {},
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(Failure.fromDioException(e, DefaultStatusCodeHandler()));
      } else {
        return left(
          Failure(errMessage: 'something went wrong (not DioException)'),
        );
      }
    }
  }
}

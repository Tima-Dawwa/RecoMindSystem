import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:recomindweb/core/helpers/custom_shared_preferences.dart';
import 'package:recomindweb/features/Home/model/cities_model.dart';
import 'package:recomindweb/features/Home/model/collab_product_model.dart';
import 'package:recomindweb/features/Home/model/profile_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_state.dart';
import 'package:recomindweb/features/Home/view%20model/home_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeService) : super(InitialHomeState());
  final HomeService homeService;
  List<CollabProductModel> products = [];
  List<CitiesModel> countries = [];
  ProfileModel? profile;

  Future<void> getCollab() async {
    var response = await homeService.getCollab();
    response.fold(
      (failure) {
        emit(FailureHomeState(failure: failure));
      },
      (res) {
        products = [];
        for (var i = 0; i < res['data'].length; i++) {
          products.add(CollabProductModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getProfile() async {
    emit(LoadingProfileState());
    var response = await homeService.getProfile();
    response.fold(
      (failure) {
        emit(FailureHomeState(failure: failure));
      },
      (res) {
        profile = ProfileModel.fromJson(res["profile"]);
        emit(SuccessProfileState());
      },
    );
  }

  Future<void> getCities() async {
    var response = await homeService.getCities();
    response.fold(
      (failure) {
        emit(FailureHomeState(failure: failure));
      },
      (res) {
        for (var i = 0; i < res['data'].length; i++) {
          countries.add(CitiesModel.fromJson(res['data'][i]));
        }
      },
    );
  }

  Future<void> homeData() async {
    // CustomSharedPreferences prefs = CustomSharedPreferences();
    emit(LoadingHomeState());
    await getCollab();
    emit(LoadingHomeState());
    await getCities();
    // if (await prefs.logged()) {
    await getProfile();
    // }
    emit(SuccessHomeState());
  }

  Future<void> changeImage({required XFile image}) async {
    emit(LoadingProfileState());
    final bytes = await image.readAsBytes();
    final filename = image.name;

    var response = await homeService.changeImage(
      body: FormData.fromMap({
        'profile_pic': MultipartFile.fromBytes(bytes, filename: filename),
      }),
    );
    response.fold(
      (failure) {
        emit(FailureHomeState(failure: failure));
      },
      (res) async {
        await getProfile();
      },
    );
  }

  Future<void> changeLocation({
    required String city,
    required String country,
  }) async {
    emit(LoadingProfileState());
    var response = await homeService.changeLocation(
      body: {'city': city, 'country': country},
    );
    response.fold(
      (failure) {
        emit(FailureHomeState(failure: failure));
      },
      (res) async {
        await getProfile();
      },
    );
  }
}

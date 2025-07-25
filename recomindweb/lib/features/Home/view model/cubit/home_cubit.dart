import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Home/model/collab_product_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_state.dart';
import 'package:recomindweb/features/Home/view%20model/home_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeService) : super(InitialHomeState());
  final HomeService homeService;
  List<CollabProductModel> products = [];

  Future<void> getCollab() async {
    emit(LoadingHomeState());
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
        emit(SuccessHomeState());
      },
    );
  }
}

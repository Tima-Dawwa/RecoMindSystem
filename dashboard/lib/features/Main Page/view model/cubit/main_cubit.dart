import 'package:dashboard/features/Main%20Page/model/chatbot_model.dart';
import 'package:dashboard/features/Main%20Page/model/countries_model.dart';
import 'package:dashboard/features/Main%20Page/model/favorites_model.dart';
import 'package:dashboard/features/Main%20Page/model/interactions_model.dart';
import 'package:dashboard/features/Main%20Page/model/notification_model.dart';
import 'package:dashboard/features/Main%20Page/model/orders_model.dart';
import 'package:dashboard/features/Main%20Page/model/sales_model.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_state.dart';
import 'package:dashboard/features/Main%20Page/view%20model/main_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this.mainService) : super(MainInitialState());

  final MainService mainService;

  List<SalesModel> sales = [];
  List<OrdersModel> orders = [];
  List<InteractionsModel> interactions = [];
  List<FavoritesModel> favorites = [];
  List<CountriesModel> countries = [];
  List<NotificationModel> notifications = [];
  ChatbotModel? chatbot;

  Future<void> getSales() async {
    emit(MainLoadingState());
    var response = await mainService.getSales();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        sales = [];
        for (var i = 0; i < res['data'].length; i++) {
          sales.add(SalesModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getChatbotUsageType() async {
    emit(MainLoadingState());
    var response = await mainService.getChatbotUsageType();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        chatbot = ChatbotModel.fromJson(res["data"]);
      },
    );
  }

  Future<void> getMostFavorited() async {
    emit(MainLoadingState());
    var response = await mainService.getMostFavorited();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        favorites = [];
        for (var i = 0; i < res['data'].length; i++) {
          favorites.add(FavoritesModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getMostUsersByCountry() async {
    emit(MainLoadingState());
    var response = await mainService.getMostUsersByCountry();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        countries = [];
        for (var i = 0; i < res['data'].length; i++) {
          countries.add(CountriesModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getTopCustomersByInteractions() async {
    emit(MainLoadingState());
    var response = await mainService.getTopCustomersByInteractions();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        interactions = [];
        for (var i = 0; i < res['data'].length; i++) {
          interactions.add(InteractionsModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getTopCustomersByOrders() async {
    emit(MainLoadingState());
    var response = await mainService.getTopCustomersByOrders();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        orders = [];
        for (var i = 0; i < res['data'].length; i++) {
          orders.add(OrdersModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getNotifications() async {
    emit(NotificationsLoadingState());
    var response = await mainService.getNotifications();
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) {
        notifications = [];
        for (var i = 0; i < res['data'].length; i++) {
          notifications.add(NotificationModel.fromJson(res["data"][i]));
        }
      },
    );
  }

  Future<void> getMainData() async {
    await getSales();
    await getChatbotUsageType();
    await getMostFavorited();
    await getMostUsersByCountry();
    await getTopCustomersByInteractions();
    await getTopCustomersByOrders();
    await getNotifications();
    emit(MainSuccessState());
  }

  Future<void> deleteNotifications({required String id}) async {
    emit(NotificationsLoadingState());
    var response = await mainService.deleteNotifications(id: id);
    response.fold(
      (failure) {
        emit(MainFailureState(failure: failure));
      },
      (res) async {
        await getMainData();
      },
    );
  }
}

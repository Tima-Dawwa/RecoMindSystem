import 'package:dashboard/features/AI/model/statistics_model.dart';
import 'package:dashboard/features/AI/model/time_model.dart';
import 'package:dashboard/features/AI/view%20model/ai_statistics_service.dart';
import 'package:dashboard/features/AI/view%20model/cubit/ai_statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiStatisticsCubit extends Cubit<AiStatisticsState> {
  AiStatisticsCubit(this.statisticsService) : super(AiStatisticsInitial());

  final AiStatisticsService statisticsService;
  List<StatisticsModel> recommendationS = [];
  List<TimeModel> recommendationT = [];
  List<StatisticsModel> chatbotS = [];
  List<TimeModel> chatbotT = [];

  Future<void> recommendationStatistics() async {
    emit(AiStatisticsLoading());
    var response = await statisticsService.recommendationStatistics();
    response.fold(
      (failure) {
        emit(AiStatisticsFailure(failure: failure));
      },
      (res) {
        recommendationS = [];
        for (var i = 0; i < res['data'].length; i++) {
          recommendationS.add(StatisticsModel.fromJson(res["data"][i]));
        }
        // emit(AiStatisticsSuccess());
      },
    );
  }

  Future<void> chatbotStatistics() async {
    emit(AiStatisticsLoading());
    var response = await statisticsService.chatbotStatistics();
    response.fold(
      (failure) {
        emit(AiStatisticsFailure(failure: failure));
      },
      (res) {
        chatbotS = [];
        for (var i = 0; i < res['data'].length; i++) {
          chatbotS.add(StatisticsModel.fromJson(res["data"][i]));
        }
        // emit(AiStatisticsSuccess());
      },
    );
  }

  Future<void> recommendationTime() async {
    emit(AiStatisticsLoading());
    var response = await statisticsService.recommendationTime();
    response.fold(
      (failure) {
        emit(AiStatisticsFailure(failure: failure));
      },
      (res) {
        recommendationT = [];
        for (var i = 0; i < res['data'].length; i++) {
          recommendationT.add(TimeModel.fromJson(res["data"][i]));
        }
        // emit(AiStatisticsSuccess());
      },
    );
  }

  Future<void> chatbotTime() async {
    emit(AiStatisticsLoading());
    var response = await statisticsService.chatbotTime();
    response.fold(
      (failure) {
        emit(AiStatisticsFailure(failure: failure));
      },
      (res) {
        chatbotT = [];
        for (var i = 0; i < res['data'].length; i++) {
          chatbotT.add(TimeModel.fromJson(res["data"][i]));
        }
        // emit(AiStatisticsSuccess());
      },
    );
  }

  Future<void> statistics() async {
    emit(AiStatisticsLoading());
    await recommendationStatistics();
    emit(AiStatisticsLoading());
    await chatbotStatistics();
    emit(AiStatisticsLoading());
    await recommendationTime();
    emit(AiStatisticsLoading());
    await chatbotTime();
    emit(AiStatisticsSuccess());
  }
}
